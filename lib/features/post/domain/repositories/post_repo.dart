import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media_clean/core/domain/paged_response.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/features/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<Either<Failure, Post>> createPost({
    required String text,
    required File image,
  });

  Future<Either<Failure, Post>> getPostById(String id);

  Future<Either<Failure, PagedResponse<Post>>> fetchPosts(
      {required int page, required int pageSize});
}
