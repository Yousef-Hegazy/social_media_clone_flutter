import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/core/di/service_locator.dart';
import 'package:social_media_clean/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_clean/features/auth/presentation/screens/login_screen.dart';
import 'package:social_media_clean/features/post/presentation/cubit/posts_cubit.dart';
import 'package:social_media_clean/features/post/presentation/screens/home_screen.dart';
import 'package:social_media_clean/splash_screen.dart';
import 'package:social_media_clean/theme/dark_mode.dart';
import 'package:social_media_clean/theme/light_mode.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  init();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthCubit>(
          create: (context) => sl<AuthCubit>()..checkAuth()),
      BlocProvider<PostsCubit>(create: (context) => sl<PostsCubit>()),
    ],
    child: BlocListener<AuthCubit, AuthState>(
      listener: (ctx, state) {
        if (state is AuthInitial || state is AuthError) {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Social Media App',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.light,
      home: BlocBuilder<AuthCubit, AuthState>(builder: (ctx, state) {
        if (state is Authenticated) {
          return const HomeScreen();
        } else if (state is AuthInitial || state is AuthError) {
          return const LoginScreen();
        } else {
          return const SplashScreen();
        }
      }),
    );
  }
}
