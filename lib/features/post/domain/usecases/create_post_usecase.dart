import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/post/domain/entities/post.dart';
import 'package:social_media_clean/features/post/domain/repositories/post_repo.dart';

class CreatePostUsecase {
  final PostRepo postRepo;
  const CreatePostUsecase(this.postRepo);

  Future<Either<Failure, Post>> call({
    required String text,
    required File image,
  }) {
    return postRepo.createPost(
      text: text,
      image: image,
    );
  }
}
