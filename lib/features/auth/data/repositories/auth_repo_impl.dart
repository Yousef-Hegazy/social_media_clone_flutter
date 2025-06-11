import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/core/helpers/handle_request.dart';
import 'package:social_media_clean/features/auth/data/models/user_model.dart';
import 'package:social_media_clean/features/auth/domain/entities/user.dart';
import 'package:social_media_clean/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final Dio _dio;

  const AuthRepoImpl(this._dio);

  @override
  Future<Either<Failure, User>> getCurrentUser() {
    return handleRequest<User>(
        request: () => _dio.get("/auth/current-user"),
        fromMap: (map) => UserModel.fromMap(map).toEntity());
  }

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return handleRequest<User>(
        request: () => _dio.post("/auth/login", data: {
              'email': email,
              'password': password,
            }),
        fromMap: (map) => UserModel.fromMap(map).toEntity());
  }

  @override
  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) {
    return handleRequest<User>(
        request: () => _dio.post("/auth/register", data: {
              'email': email,
              'password': password,
              'name': name,
            }),
        fromMap: (map) => UserModel.fromMap(map).toEntity());
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required User user,
    File? image,
  }) async {
    final model = UserModel.fromEntity(user);

    final formData = FormData.fromMap({
      'user': {
        'name': model.name,
        'email': model.email,
        'bio': model.bio,
      },
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
    });

    return handleRequest<User>(
      request: () => _dio.post("/auth/update-user",
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          )),
      fromMap: (map) => UserModel.fromMap(map).toEntity(),
    );
  }
}
