import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_media_clean/core/network/auth_interceptor.dart';
import 'package:social_media_clean/core/utils/constants.dart';

class DioClient {
  static Dio create(FlutterSecureStorage secureStorage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
        headers: {"Content-Type": "application/json"},
        responseType: ResponseType.json,
        contentType: "application/json",
      ),
    );

    dio.interceptors.add(AuthInterceptor(secureStorage));

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }
}
