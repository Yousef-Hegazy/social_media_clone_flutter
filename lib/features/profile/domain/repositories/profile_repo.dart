import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/profile/domain/entities/profile.dart';

abstract class ProfileRepo {
  Future<Either<Failure, Profile>> getProfile(String userId);
}
