import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/core/widgets/app_text_form_field.dart';
import 'package:social_media_clean/features/auth/domain/entities/user.dart';
import 'package:social_media_clean/features/auth/presentation/cubit/auth_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bio.text = widget.user.bio ?? '';
  }

  @override
  void dispose() {
    _bio.dispose();
    final currentState = _formKey.currentState;

    if (currentState != null) {
      currentState.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.primary,
          title: const Text("Edit Profile"),
          actions: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (ctx, state) => IconButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check_rounded),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Bio"),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextFormField(
                    controller: _bio,
                    hintText: 'Bio',
                    textInputAction: TextInputAction.next,
                    minLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your bio';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
