import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/core/utils/constants.dart';
import 'package:social_media_clean/core/widgets/app_button.dart';
import 'package:social_media_clean/features/auth/domain/entities/user.dart';
import 'package:social_media_clean/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_clean/features/auth/presentation/screens/login_screen.dart';
import 'package:social_media_clean/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:social_media_clean/features/profile/presentation/widgets/bio_box.dart';
import 'package:social_media_clean/features/profile/presentation/widgets/posts_box.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Scaffold(
        body: state is AuthLoading
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : state is Authenticated || state is ProfileError
                ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: ProfileView(user: (state as Authenticated).user),
                    ),
                  )
                : Center(
                    child: AppButton(
                      text: "Please login first",
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const LoginScreen()),
                        (route) => false,
                      ),
                    ),
                  ),
      );
    });
  }
}

class ProfileView extends StatelessWidget {
  final User user;

  const ProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.chevron_left_rounded),
                ),
                Text(
                  user.name,
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => EditProfileScreen(user: user)),
                  ),
                  icon: Icon(Icons.settings_rounded),
                )
              ],
            ),
          ),
          SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Text(
                user.email,
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 25.0),
          user.imageUrl != null
              ? Hero(
                  tag: "profile_image_${user.id}",
                  child: CachedNetworkImage(
                    imageUrl: "${Constants.baseUrl}/files/${user.imageUrl}",
                    errorWidget: (ctx, url, error) => Icon(Icons.error_rounded),
                    placeholder: (context, url) => const SizedBox(
                      width: 200,
                      height: 200,
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 250.0,
                  width: 250.0,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: colors.secondary,
                    borderRadius: BorderRadius.circular(250.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_2_rounded,
                      size: 72.0,
                      color: colors.primary,
                    ),
                  ),
                ),
          SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Text(
                  "Bio",
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          BioBox(text: user.bio ?? ""),
          SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Text(
                  "Posts",
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          PostsBox(text: user.bio ?? ""),
        ],
      ),
    );
  }
}
