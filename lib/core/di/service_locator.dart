import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media_clean/core/network/dio_client.dart';
import 'package:social_media_clean/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:social_media_clean/features/auth/domain/repositories/auth_repo.dart';
import 'package:social_media_clean/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:social_media_clean/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_media_clean/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_media_clean/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:social_media_clean/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_clean/features/post/data/repositories/post_repo_impl.dart';
import 'package:social_media_clean/features/post/domain/repositories/post_repo.dart';
import 'package:social_media_clean/features/post/domain/usecases/create_post_usecase.dart';
import 'package:social_media_clean/features/post/domain/usecases/get_posts_usecase.dart';
import 'package:social_media_clean/features/post/presentation/cubit/posts_cubit.dart';

final sl = GetIt.instance;

void init() {
  // register FlutterSecureStorage
  sl.registerLazySingleton(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    ),
  );
  // register Dio for http requests
  sl.registerLazySingleton<Dio>(
      () => DioClient.create(sl<FlutterSecureStorage>()));

  // Auth
  sl.registerFactory<AuthRepo>(() => AuthRepoImpl(sl<Dio>()));
  sl.registerFactory(() => LoginUsecase(sl()));
  sl.registerFactory(() => RegisterUsecase(sl()));
  sl.registerFactory(() => GetCurrentUserUsecase(sl()));
  sl.registerFactory(() => UpdateProfileUsecase(sl()));
  sl.registerLazySingleton(
    () => AuthCubit(
      sl<FlutterSecureStorage>(),
      sl<LoginUsecase>(),
      sl<RegisterUsecase>(),
      sl<GetCurrentUserUsecase>(),
      sl<UpdateProfileUsecase>(),
    ),
  );

  // Posts
  sl.registerFactory<PostRepo>(() => PostRepoImpl(sl<Dio>()));
  sl.registerFactory<GetPostsUsecase>(() => GetPostsUsecase(sl<PostRepo>()));
  sl.registerFactory<CreatePostUsecase>(
      () => CreatePostUsecase(sl<PostRepo>()));
  sl.registerLazySingleton<PostsCubit>(
      () => PostsCubit(sl<GetPostsUsecase>(), sl<CreatePostUsecase>()));
}
