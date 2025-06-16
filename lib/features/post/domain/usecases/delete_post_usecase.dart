import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/post/domain/repositories/post_repo.dart';

class DeletePostUsecase {
  final PostRepo _postRepo;

  const DeletePostUsecase(this._postRepo);

  Future<Either<Failure, void>> call({required String id}) {
    return _postRepo.deletePost(id);
  }
}
