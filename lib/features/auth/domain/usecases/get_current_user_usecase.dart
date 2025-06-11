import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/auth/domain/entities/user.dart';
import 'package:social_media_clean/features/auth/domain/repositories/auth_repo.dart';

class GetCurrentUserUsecase {
  final AuthRepo _authRepo;
  const GetCurrentUserUsecase(this._authRepo);

  Future<Either<Failure, User>> call() async {
    return _authRepo.getCurrentUser();
  }
}
