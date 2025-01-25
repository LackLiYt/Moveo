import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:moveo/constants/constants.dart';
import 'package:flutter/widgets.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
}

class AuthAPI extends ChangeNotifier {
  Client client = Client();
  late final Account account;

  late User _currentUser;

  AuthStatus _status = AuthStatus.uninitialized;

  // Getters
  User get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get username => _currentUser.name;
  String? get email => _currentUser.email;
  String? get userid => _currentUser.$id;

  AuthAPI() {
    init();
    loadUser();
  }

  init() {
    client
        .setEndpoint(AppwriteConstants.endPoint)
        .setProject(AppwriteConstants.projectId)
        .setSelfSigned();
    account = Account(client);
  }

  loadUser() async {
    try {
      final user = await account.get();
      _status = AuthStatus.authenticated;
      _currentUser = user;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<User> createUser(
      {required String email, required String password}) async {
    try {
      final user = await account.create(
          userId: ID.unique(),
          email: email,
          password: password,
          name: 'LackLi');
      return user;
    } finally {
      notifyListeners();
    }
  }

  Future<Session> createEmailSession(
      {required String email, required String password}) async {
    try {
      final session = await account.createEmailPasswordSession(
          email: email, password: password);
      _currentUser = await account.get();
      _status = AuthStatus.authenticated;
      return session;
    } finally {
      notifyListeners();
    }
  }

  signInWithProvider({required String provider}) async {
    try {
      final session =
          await account.createOAuth2Session(provider: _mapProvider(provider));
      _currentUser = await account.get();
      _status = AuthStatus.authenticated;
      return session;
    } finally {
      notifyListeners();
    }
  }

  signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<Preferences> getUserPreferences() async {
    return await account.getPrefs();
  }

  updatePereferences({required String bio}) async {
    return account.updatePrefs(prefs: {'bio': bio});
  }

  // Helper to map provider string to OAuthProvider
  OAuthProvider _mapProvider(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return OAuthProvider.google;
      case 'github':
        return OAuthProvider.github;
      case 'facebook':
        return OAuthProvider.facebook;
      // Add other providers as needed
      default:
        throw ArgumentError('Unsupported provider: $provider');
    }
  }
}
