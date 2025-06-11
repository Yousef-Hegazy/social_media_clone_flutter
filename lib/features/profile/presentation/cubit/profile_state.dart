part of 'profile_cubit.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class UpdatingProfile extends ProfileState {}

final class ProfileUpdated extends ProfileState {
  final Profile profile;

  ProfileUpdated(this.profile);
}

final class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
