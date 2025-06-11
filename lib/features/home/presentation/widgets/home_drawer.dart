import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_clean/features/home/presentation/widgets/home_drawer_tile.dart';
import 'package:social_media_clean/features/profile/presentation/screens/profile_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
          child: Column(
            children: [
              Icon(
                CupertinoIcons.person,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 20),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(height: 20),
              HomeDrawerTile(
                title: "H O M E",
                icon: CupertinoIcons.home,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              HomeDrawerTile(
                title: "P R O F I L E",
                icon: CupertinoIcons.person_alt,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              HomeDrawerTile(
                title: "S E A R C H",
                icon: CupertinoIcons.search,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              HomeDrawerTile(
                title: "S E T T I N G S",
                icon: CupertinoIcons.settings,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Spacer(),
              HomeDrawerTile(
                title: "L O G O U T",
                onTap: () {
                  Navigator.pop(context);

                  context.read<AuthCubit>().logout();
                },
                icon: Icons.logout_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
