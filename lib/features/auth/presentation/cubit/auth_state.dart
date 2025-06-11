part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

final class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}
