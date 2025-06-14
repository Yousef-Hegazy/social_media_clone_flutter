import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/core/utils/constants.dart';
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
  PlatformFile? _image;

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

  Future<void> pickImage() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
      dialogTitle: 'Select Profile Picture',
    );

    if (res != null && res.files.isNotEmpty) {
      setState(() {
        _image = res.files.first;
      });
    } else {
      setState(() {
        _image = null;
      });
    }
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
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is ProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is Authenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile updated successfully')),
                  );

                  Navigator.pop(context);
                }
              },
              builder: (ctx, state) => IconButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<AuthCubit>().updateUser(
                                user: widget.user.copyWith(bio: _bio.text),
                                image:
                                    _image != null ? File(_image!.path!) : null,
                              );
                        }
                      },
                icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: state is AuthLoading
                        ? const CircularProgressIndicator.adaptive()
                        : const Icon(Icons.check_rounded)),
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
                  InkWell(
                    onTap: pickImage,
                    borderRadius: BorderRadius.circular(250.0),
                    child: Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250.0),
                      ),
                      child: _image != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(File(_image!.path!)),
                            )
                          : widget.user.imageUrl != null
                              ? Hero(
                                  tag: "profile_image_${widget.user.id}",
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${Constants.baseUrl}/files/${widget.user.imageUrl}",
                                    errorWidget: (ctx, url, error) =>
                                        Icon(Icons.error_rounded),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(250.0),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
