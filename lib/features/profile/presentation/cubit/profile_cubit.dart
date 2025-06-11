import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/features/profile/domain/entities/profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
}
