import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media_clean/core/utils/constants.dart';
import 'package:social_media_clean/features/auth/presentation/cubit/auth_cubit.dart';

final class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.read(key: Constants.tokenKey);

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401 || response.statusCode == 403) {
      await GetIt.I<AuthCubit>().logout();
    }
    super.onResponse(response, handler);
  }
}
