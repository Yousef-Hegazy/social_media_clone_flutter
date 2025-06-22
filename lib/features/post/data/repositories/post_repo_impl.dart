import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:social_media_clean/core/domain/paged_response.dart';
import 'package:social_media_clean/core/error/failure.dart';
import 'package:social_media_clean/core/helpers/handle_request.dart';
import 'package:social_media_clean/features/post/data/models/post_model.dart';
import 'package:social_media_clean/features/post/domain/entities/post.dart';
import 'package:social_media_clean/features/post/domain/repositories/post_repo.dart';

class PostRepoImpl implements PostRepo {
  final Dio _dio;

  const PostRepoImpl(this._dio);

  @override
  Future<Either<Failure, Post>> createPost({
    required String text,
    required File image,
  }) async {
    final formData = FormData();

    formData.files.add(
      MapEntry(
        'post',
        MultipartFile.fromString(
          jsonEncode({
            'text': text,
          }),
          contentType: DioMediaType("application", "json"),
        ),
      ),
    );

    formData.files.add(MapEntry(
      'image',
      await MultipartFile.fromFile(
        image.path,
        filename: image.path.split(Platform.pathSeparator).last,
      ),
    ));

    return handleRequest<Post>(
      request: () => _dio.post("/posts", data: formData),
      fromMap: (map) => PostModel.fromMap(map).toEntity(),
    );
  }

  @override
  Future<Either<Failure, PagedResponse<Post>>> fetchPosts({
    required int page,
    required int pageSize,
  }) async {
    return handlePagedRequest<Post>(
      request: () => _dio.get("/posts", queryParameters: {
        'page': page,
        'pageSize': pageSize,
      }),
      fromMap: (map) => PostModel.fromMap(map).toEntity(),
    );
  }

  @override
  Future<Either<Failure, Post>> getPostById(String id) {
    return handleRequest<Post>(
      request: () => _dio.get("/posts/$id"),
      fromMap: (map) => PostModel.fromMap(map).toEntity(),
    );
  }

  @override
  Future<Either<Failure, void>> deletePost(String id) {
    return handleVoidRequest(
      request: () => _dio.delete("/posts/$id"),
    );
  }
}
