import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/auth_api.dart';
import 'package:moveo/apis/user_api.dart';
import 'package:moveo/core/utils.dart';
import 'package:moveo/features/auth/view/login_page.dart';
import 'package:moveo/features/home/view/home_view.dart';
import 'package:moveo/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
  final AuthController = ref.watch(authControllerProvider.notifier);
  return AuthController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  //стан = Завантажується/ state = isLoading

  Future<model.User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.sighUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.massage),
      (r) async {
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
        res2.fold((l) => showSnackBar(context, l.massage), (r) {
          showSnackBar(context, ' Account created! Pleaseee lock in ');
        Navigator.push(context, LoginPage.route());
        });

      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    res.fold((l) => showSnackBar(context, l.massage), (r) {
      Navigator.push(context, HomeView.route());
    });
  }
}
