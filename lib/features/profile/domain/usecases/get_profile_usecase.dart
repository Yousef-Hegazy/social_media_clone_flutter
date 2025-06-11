import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/profile/domain/entities/profile.dart';
import 'package:social_media_clean/features/profile/domain/repositories/profile_repo.dart';

class GetProfileUsecase {
  final ProfileRepo _profileRepo;
  const GetProfileUsecase(this._profileRepo);

  Future<Either<Failure, Profile>> call(String id) {
    return _profileRepo.getProfile(id);
  }
}
