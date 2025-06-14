import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/domain/paged_response.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/post/domain/entities/post.dart';
import 'package:social_media_clean/features/post/domain/repositories/post_repo.dart';

class GetPostsUsecase {
  final PostRepo postRepo;

  GetPostsUsecase(this.postRepo);

  Future<Either<Failure, PagedResponse<Post>>> call({
    required int page,
    required int pageSize,
  }) {
    return postRepo.fetchPosts(
      page: page,
      pageSize: pageSize,
    );
  }
}
