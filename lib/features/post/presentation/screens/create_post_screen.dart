import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/core/widgets/app_text_form_field.dart';
import 'package:social_media_clean/features/post/presentation/cubit/posts_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _text = TextEditingController();
  PlatformFile? _image;

  @override
  void dispose() {
    _text.dispose();
    final currentState = _formKey.currentState;

    if (currentState != null) {
      currentState.dispose();
    }

    super.dispose();
  }

  Future<void> _pickImage() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
      dialogTitle: 'Select Post Image',
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
          title: const Text("Create Post"),
          actions: [
            BlocConsumer<PostsCubit, PostsState>(
              listener: (context, state) {
                if (state is PostCreationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is PostCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile updated successfully')),
                  );

                  Navigator.pop(context);
                }
              },
              builder: (ctx, state) => IconButton(
                onPressed: state is PostsLoading
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<PostsCubit>().createPost(
                                text: _text.text,
                                image: File(_image!.path!),
                              );
                        }
                      },
                icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: state is PostsLoading
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
                    onTap: _pickImage,
                    child: _image != null
                        ? Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: FileImage(
                                  File(_image!.path!),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: const Icon(Icons.image),
                          ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Content"),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextFormField(
                    controller: _text,
                    hintText: 'Content',
                    textInputAction: TextInputAction.next,
                    minLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the post content';
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
