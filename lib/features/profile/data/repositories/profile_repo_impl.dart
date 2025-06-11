import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/core/helpers/handle_request.dart';
import 'package:social_media_clean/features/profile/data/models/profile_model.dart';
import 'package:social_media_clean/features/profile/domain/entities/profile.dart';
import 'package:social_media_clean/features/profile/domain/repositories/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final Dio _dio;

  const ProfileRepoImpl(this._dio);

  @override
  Future<Either<Failure, Profile>> getProfile(String userId) async {
    return handleRequest<Profile>(
      request: () => _dio.get("/profile/$userId"),
      fromMap: (map) => ProfileModel.fromMap(map).toEntity(),
    );
  }
}
