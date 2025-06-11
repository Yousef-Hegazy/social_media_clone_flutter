import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/auth/domain/entities/user.dart';
import 'package:social_media_clean/features/auth/domain/repositories/auth_repo.dart';

class LoginUsecase {
  final AuthRepo _authRepo;
  const LoginUsecase(this._authRepo);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    return _authRepo.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
