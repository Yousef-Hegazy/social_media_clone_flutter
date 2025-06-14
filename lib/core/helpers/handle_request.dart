import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:social_media_clean/core/domain/paged_response.dart';
import 'package:social_media_clean/core/error/api_error_response.dart';
import 'package:social_media_clean/core/error/failure.dart';

Future<Either<Failure, T>> handleRequest<T>({
  required Future<Response> Function() request,
  required T Function(Map<String, dynamic>) fromMap,
}) async {
  try {
    final res = await request();

    if (res.statusCode == 200) {
      final result = fromMap(res.data);
      return right(result);
    } else {
      final err = ApiErrorResponse.fromMap(res.data);
      return left(ServerFailure(err.detail ?? "An unknown error occurred"));
    }
  } on DioException catch (e) {
    if (e.response?.data != null) {
      final err = ApiErrorResponse.fromMap(e.response!.data);
      return left(ServerFailure(err.detail ?? "An unknown error occurred"));
    }
    return left(ServerFailure(e.message ?? "An unknown error occurred"));
  } catch (e) {
    return left(ServerFailure(e.toString()));
  }
}

Future<Either<Failure, PagedResponse<T>>> handlePagedRequest<T>({
  required Future<Response> Function() request,
  required T Function(Map<String, dynamic>) fromMap,
}) async {
  try {
    final res = await request();

    if (res.statusCode == 200) {
      final data = res.data as Map<String, dynamic>;

      final pagedResponse = PagedResponse<T>.fromMap(data, fromMap);

      return right(pagedResponse);
    } else {
      final err = ApiErrorResponse.fromMap(res.data);
      return left(ServerFailure(err.detail ?? "An unknown error occurred"));
    }
  } on DioException catch (e) {
    if (e.response?.data != null) {
      final err = ApiErrorResponse.fromMap(e.response!.data);
      return left(ServerFailure(err.detail ?? "An unknown error occurred"));
    }
    return left(ServerFailure(e.message ?? "An unknown error occurred"));
  } catch (e) {
    return left(ServerFailure(e.toString()));
  }
}
