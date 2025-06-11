import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/auth/domain/entities/user.dart';
import 'package:social_media_clean/features/auth/domain/repositories/auth_repo.dart';

class RegisterUsecase {
  final AuthRepo _authRepo;
  const RegisterUsecase(this._authRepo);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return _authRepo.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
  }
}
