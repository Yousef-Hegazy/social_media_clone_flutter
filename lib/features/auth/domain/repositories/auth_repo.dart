import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/auth/domain/entities/user.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, User>> updateProfile({
    required User user,
    File? image,
  });
}
