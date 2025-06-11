import "dart:io";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:social_media_clean/core/utils/constants.dart";
import "package:social_media_clean/features/auth/domain/entities/user.dart";
import "package:social_media_clean/features/auth/domain/usecases/get_current_user_usecase.dart";
import "package:social_media_clean/features/auth/domain/usecases/login_usecase.dart";
import "package:social_media_clean/features/auth/domain/usecases/register_usecase.dart";
import "package:social_media_clean/features/auth/domain/usecases/update_profile_usecase.dart";

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FlutterSecureStorage _secureStorage;
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;

  AuthCubit(
    this._secureStorage,
    this._loginUsecase,
    this._registerUsecase,
    this._getCurrentUserUsecase,
    this._updateProfileUsecase,
  ) : super(AuthInitial());

  Future<bool> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final res = await _loginUsecase(
      email: email,
      password: password,
    );

    return res.fold((e) {
      emit(AuthError(e.message));
      return false;
    }, (user) {
      _secureStorage.write(key: Constants.tokenKey, value: user.token);
      emit(Authenticated(user));
      return true;
    });
  }

  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());

    final res =
        await _registerUsecase(email: email, password: password, name: name);

    return res.fold((e) {
      emit(AuthError(e.message));
      return false;
    }, (user) {
      _secureStorage.write(key: Constants.tokenKey, value: user.token);
      emit(Authenticated(user));
      return true;
    });
  }

  Future<void> getCurrentUser() async {
    if (state is! AuthLoading) emit(AuthLoading());

    final res = await _getCurrentUserUsecase();

    res.fold((e) => emit(AuthError(e.message)), (user) async {
      await _secureStorage.write(key: Constants.tokenKey, value: user.token);
      emit(Authenticated(user));
    });
  }

  Future<void> logout() async {
    emit(AuthLoading());

    await _secureStorage.delete(key: Constants.tokenKey);

    emit(AuthInitial());
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: Constants.tokenKey);
    return token != null;
  }

  Future<void> checkAuth() async {
    emit(AuthLoading());

    final isAuth = await isAuthenticated();

    if (isAuth) {
      await getCurrentUser();
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> updateUser({required User user, File? image}) async {
    emit(AuthLoading());

    final res = await _updateProfileUsecase(user: user, image: image);

    res.fold((e) {
      emit(AuthError(e.message));
    }, (updatedUser) {
      _secureStorage.write(key: Constants.tokenKey, value: updatedUser.token);
      emit(Authenticated(updatedUser));
    });
  }
}
