import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/core/widgets/app_button.dart';
import 'package:social_media_clean/core/widgets/app_text_field.dart';
import 'package:social_media_clean/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_clean/features/auth/presentation/screens/login_screen.dart';
import 'package:social_media_clean/features/home/presentation/screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    email.dispose();
    name.dispose();
    password.dispose();
    confirmPassword.dispose();
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (email.text.isEmpty ||
        password.text.isEmpty ||
        name.text.isEmpty ||
        confirmPassword.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill in all fields.")));
      return;
    }

    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    final isAuth = await context.read<AuthCubit>().registerWithEmailAndPassword(
          email: email.text,
          password: password.text,
          name: name.text,
        );

    if (!mounted) return;

    if (context.read<AuthCubit>().state is AuthError) {
      final state = context.read<AuthCubit>().state;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((state is AuthError) ? state.message : 'Unknown error'),
        ),
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
                    "Welcome, we are happy to have you!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  AppTextField(
                    controller: name,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      emailFocusNode.requestFocus();
                    },
                    prefixIcon: CupertinoIcons.person,
                    hintText: "Name",
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
                    textInputAction: TextInputAction.next,
                    controller: password,
                    hintText: "Password",
                    prefixIcon: CupertinoIcons.lock,
                    isPasswordField: true,
                    onSubmitted: (_) => confirmPasswordFocusNode.requestFocus(),
                  ),

                  SizedBox(height: 20),

                  AppTextField(
                    focusNode: confirmPasswordFocusNode,
                    controller: confirmPassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => register(),
                    hintText: "Confirm Password",
                    prefixIcon: CupertinoIcons.lock,
                    isPasswordField: true,
                  ),

                  SizedBox(height: 20),
                  // sign up button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (ctx, state) => AppButton(
                      text: "Sign Up",
                      icon: Icons.person_add_rounded,
                      onPressed: register,
                      isLoading: state is AuthLoading,
                    ),
                  ),

                  SizedBox(height: 20),

                  // login button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        text: "Login",
                        isLoading: state is AuthLoading,
                        icon: Icons.login_rounded,
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                      );
                    },
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
