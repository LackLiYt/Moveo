import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/auth_api.dart';
import 'package:moveo/apis/user_api.dart';
import 'package:moveo/core/utils.dart';
import 'package:moveo/features/auth/view/login_page.dart';
import 'package:moveo/features/home/view/home_view.dart';
import 'package:moveo/models/user_model.dart';
import 'package:appwrite/appwrite.dart';

// Create a provider for the current user account
final currentUserAccountProvider = FutureProvider((ref) async {
  try {
    final authAPI = ref.watch(authAPIProvider);
    return await authAPI.currentUserAccount();
  } on AppwriteException catch (e) {
    // If the error is due to unauthorized access, return null instead of throwing
    if (e.message?.contains('unauthorized') ?? false) {
      return null;
    }
    rethrow;
  }
});

final userDetailsProvider = FutureProvider.autoDispose((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  final user = await authController.currentUser();
  if (user == null) {
    return null;
  }
  return await ref.watch(userAPIProvider).getUserData(user.$id);
});

final getUserDetailsByIdProvider = FutureProvider.family.autoDispose((ref, String uid) async {
  return await ref.watch(userAPIProvider).getUserData(uid);
});

// Provider to fetch all users excluding the current user
final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final userAPI = ref.watch(userAPIProvider);
  final currentUser = await ref.watch(currentUserAccountProvider.future); // Get current user

  if (currentUser == null) {
    print("allUsersProvider: Current user is null.");
    return []; // Return empty list if user is not logged in
  }

  print("allUsersProvider: Current user ID is ${currentUser.$id}");

  final usersResult = await userAPI.getAllUsers();

  return usersResult.fold(
    (failure) {
      print("allUsersProvider: Error fetching users: ${failure.massage}");
      return []; // Return an empty list in case of failure
    },
    (documents) {
      final allUsers = documents.map((doc) => UserModel.fromMap(doc.data)).toList();
      print("allUsersProvider: Fetched ${allUsers.length} users.");
      // Filter out the current user
      final filteredUsers = allUsers.where((user) => user.uid != currentUser.$id).toList();
      print("allUsersProvider: Filtered down to ${filteredUsers.length} users.");
      return filteredUsers;
    },
  );
});

// Create the auth controller provider
final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    ref: ref,
  );
});

// Create a provider for user details that depends on the current user account
final currentUserDetailsProvider = FutureProvider.autoDispose((ref) async {
  final currentUserAccount = await ref.watch(currentUserAccountProvider.future);
  
  if (currentUserAccount == null) {
    return null;
  }
  
  final userAPI = ref.watch(userAPIProvider);
  final userDataResult = await userAPI.getUserData(currentUserAccount.$id);
  
  return userDataResult.fold(
    (failure) => null,
    (document) => UserModel.fromMap(document.data),
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  final Ref _ref;

  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
    required Ref ref,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        _ref = ref,
        super(false);
  //стан = Завантажується/ state = isLoading

  Future<model.User?> currentUser() => _authAPI.currentUserAccount();

  Future<void> logout() async {
    state = true;
    try {
      await _authAPI.logout();
      _ref.invalidate(currentUserDetailsProvider);
      _ref.invalidate(currentUserAccountProvider);
    } finally {
      state = false;
    }
  }

  void logoutAndNavigate(BuildContext context) async {
    try {
      await logout();
      if (!context.mounted) return;
      
      Navigator.pushReplacement(
        context,
        LoginPage.route(),
      );
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, 'Error logging out: $e');
    }
  }

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    try {
      final res = await _authAPI.sighUp(
        email: email,
        password: password,
      );
      
      res.fold(
        (l) {
          showSnackBar(context, l.massage);
          state = false;
        },
        (r) async {
          try {
            UserModel userModel = UserModel(
              email: email,
              name: getNameFromEmail(email),
              followers: const [],
              following: const [],
              profilePic: '',
              bannerPic: '',
              uid: r.$id,
              bio: '',
              isCooked: false,
            );
            
            final res2 = await _userAPI.saveUserData(userModel);
            res2.fold(
              (l) => showSnackBar(context, l.massage),
              (r) {
                showSnackBar(context, 'Account created! Please log in');
                if (!context.mounted) return;
                Navigator.push(context, LoginPage.route());
              },
            );
          } catch (e) {
            showSnackBar(context, 'Error creating user profile: $e');
          }
        },
      );
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e');
    }
    state = false;
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    try {
      _ref.invalidate(currentUserDetailsProvider);
      _ref.invalidate(currentUserAccountProvider);

      final res = await _authAPI.login(
        email: email,
        password: password,
      );
      
      res.fold(
        (l) {
          showSnackBar(context, l.massage);
          state = false;
        },
        (r) async {
          try {
            await Future.delayed(const Duration(milliseconds: 500));
            
            final currentUser = await _authAPI.currentUserAccount();
            if (currentUser != null) {
              final userDataResult = await _userAPI.getUserData(currentUser.$id);
              
              userDataResult.fold(
                (failure) async {
                  if (!context.mounted) return;
                  showSnackBar(context, 'Error accessing user data: ${failure.massage}');
                  await logout();
                },
                (userData) {
                  _ref.invalidate(currentUserDetailsProvider);
                  _ref.invalidate(currentUserAccountProvider);
                  
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    HomeView.route(),
                  );
                },
              );
            } else {
              if (!context.mounted) return;
              showSnackBar(context, 'Login failed - please try again');
              await logout();
            }
          } catch (e) {
            if (!context.mounted) return;
            showSnackBar(context, 'An error occurred during login');
            await logout();
          }
          state = false;
        },
      );
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e');
      state = false;
    }
  }
}
