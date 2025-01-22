import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/auth_api.dart';
import 'package:moveo/core/utils.dart';

final authControllerProvider = 
StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI}): _authAPI = authAPI, super(false);
  //стан = Завантажується/ state = isLoading

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
      res.fold(
        (l) => showSnackBar(context, l.massage),
         (r) => print(r.email)
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
      res.fold(
        (l) => showSnackBar(context, l.massage),
         (r) => print(r.userId)
         );
  }
   
}