import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/core/widgets/app_button.dart';
import 'package:social_media_clean/core/widgets/app_text_field.dart';
import 'package:social_media_clean/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_clean/features/auth/presentation/screens/register_screen.dart';
import 'package:social_media_clean/features/home/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields.')));
      return;
    }

    final isAuth = await context
        .read<AuthCubit>()
        .loginWithEmailAndPassword(email: email.text, password: password.text);

    if (!mounted) return;

    if (context.read<AuthCubit>().state is AuthError) {
      final AuthState state = context.read<AuthCubit>().state;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text((state is AuthError) ? state.message : 'Unknown error')),
      );
    }

    if (isAuth) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Icon(
                    Icons.lock_open_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  SizedBox(height: 20),

                  // Welcome back msg
                  Text(
                    "Welcome back, we missed you!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  // email input
                  AppTextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      passwordFocusNode.requestFocus();
                    },
                    prefixIcon: CupertinoIcons.mail,
                    hintText: "Email",
                  ),

                  SizedBox(height: 20),

                  // pw input
                  AppTextField(
                    focusNode: passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      login();
                    },
                    controller: password,
                    hintText: "Password",
                    prefixIcon: CupertinoIcons.lock,
                    isPasswordField: true,
                  ),

                  SizedBox(height: 20),
                  // login button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (ctx, state) => AppButton(
                      text: "Login",
                      icon: Icons.login_rounded,
                      onPressed: login,
                      isLoading: state is AuthLoading,
                    ),
                  ),

                  SizedBox(height: 20),
                  // sign up button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (ctx, state) => AppButton(
                      isLoading: state is AuthLoading,
                      text: "Sign Up",
                      icon: Icons.person_add_rounded,
                      onPressed: () => Navigator.of(
                        context,
                      ).push(
                        MaterialPageRoute(
                          builder: (ctx) => const RegisterScreen(),
                        ),
                      ), // push
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
