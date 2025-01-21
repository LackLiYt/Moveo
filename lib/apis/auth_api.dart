import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:fpdart/fpdart.dart';
import 'package:moveo/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authAPIProvider = Provider((ref) {});

// Використовувавти Account коли реєструємо юзерів
// Коли хочемо доступитися до даних юзера model.User
abstract class IAuthAPI {
  FutureEither<model.User> sighUp({
    required String email,
    required String password
  });

}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

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

}