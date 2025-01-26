import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:fpdart/fpdart.dart';
import 'package:moveo/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/core/providers.dart';


final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(
    account: account, 
    );
});

// Використовувавти Account коли реєструємо юзерів
// Коли хочемо доступитися до даних юзера model.User
abstract class IAuthAPI {
  FutureEither<model.User> sighUp({
    required String email,
    required String password
  });

  FutureEither<model.Session> login({
    required String email,
    required String password
  });

  Future<model.User?> currentUserAccount();

}



class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

  @override
  Future<model.User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    }
     catch (e) {
      return null;
  }
  }


  @override
  FutureEither<model.User> sighUp({
    required String email,
     required String password,
     }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
         email: email,
          password: password
          );
          return right(account);
    } on AppwriteException catch(e,stackTrace) {
      return left(
        Failure(e.message ?? 'Some horrible bullshit happened', stackTrace),
      );
    }
     catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace),
      );
    }
  }
  
  @override
  FutureEither<model.Session> login({
    required String email,
     required String password
     }) async {
    try {
      final session = await _account.createEmailPasswordSession(
         email: email,
          password: password
          );
          return right(session);
    } on AppwriteException catch(e,stackTrace) {
      return left(
        Failure(e.message ?? 'Some horrible bullshit happened', stackTrace),
      );
    }
     catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace),
      );
    }
  }
  
  
}