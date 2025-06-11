import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/auth/domain/entities/user.dart';
import 'package:social_media_clean/features/auth/domain/repositories/auth_repo.dart';

class UpdateProfileUsecase {
  final AuthRepo _authRepo;

  UpdateProfileUsecase(this._authRepo);

  Future<Either<Failure, User>> call({required User user, File? image}) {
    return _authRepo.updateProfile(user: user, image: image);
  }
}
