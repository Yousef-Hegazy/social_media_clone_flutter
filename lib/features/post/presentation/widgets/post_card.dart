import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/core/utils/constants.dart';
import 'package:social_media_clean/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_clean/features/post/domain/entities/post.dart';
import 'package:social_media_clean/features/post/presentation/cubit/posts_cubit.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  void showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Post"),
        content: Text(
            "Are you sure you want to delete this post?\n\n\"${widget.post.text}\""),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<PostsCubit>().deletePost(widget.post.id);
              Navigator.pop(ctx);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: colors.tertiary,
            border: Border.all(color: colors.primary, width: 0.5),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withAlpha(30),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PostImage(imageUrl: widget.post.imageUrl),
              const SizedBox(height: 16),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (ctx, state) {
                  if (state is Authenticated &&
                      state.user.id.toLowerCase() ==
                          widget.post.userId.toLowerCase()) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "You",
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          BlocConsumer<PostsCubit, PostsState>(
                            listener: (ctx, state) {
                              if (state.deletionError != null) {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.deletionError!)),
                                );
                                context.read<PostsCubit>().clearFlags();
                              } else if (state.deletionSuccess == true &&
                                  state.deletionError == null) {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Post deleted successfully'),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              final isDeleting = state.isFetching;

                              return GestureDetector(
                                onTap: showDeleteConfirm,
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: isDeleting
                                      ? CircularProgressIndicator.adaptive(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(
                                              colors.primary),
                                        )
                                      : Icon(
                                          CupertinoIcons.delete,
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return _PaddedText(
                    widget.post.username,
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
              ),
              _PaddedText(
                widget.post.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        // BlocBuilder<AuthCubit, AuthState>(
        //   builder: (ctx, state) {
        //     if (state is Authenticated &&
        //         state.user.id.toLowerCase() ==
        //             widget.post.userId.toLowerCase()) {
        //       return Positioned(
        //         top: 20,
        //         right: 20,
        //         child: BlocConsumer<PostsCubit, PostsState>(
        //           listener: (ctx, state) {
        //             if (state.deletionError != null) {
        //               ScaffoldMessenger.of(context).removeCurrentSnackBar();
        //               ScaffoldMessenger.of(context).showSnackBar(
        //                 SnackBar(content: Text(state.deletionError!)),
        //               );
        //               context.read<PostsCubit>().clearFlags();
        //             } else if (state.deletionSuccess == true &&
        //                 state.deletionError == null) {
        //               ScaffoldMessenger.of(context).removeCurrentSnackBar();
        //               ScaffoldMessenger.of(context).showSnackBar(
        //                 const SnackBar(
        //                     content: Text('Post deleted successfully')),
        //               );
        //             }
        //           },
        //           builder: (context, state) {
        //             final isDeleting = state.isFetching;

        //             return IconButton(
        //               color: Colors.red.shade500,
        //               onPressed: showDeleteConfirm,
        //               icon: SizedBox(
        //                 width: 20,
        //                 height: 20,
        //                 child: isDeleting
        //                     ? CircularProgressIndicator.adaptive(
        //                         strokeWidth: 2,
        //                         valueColor:
        //                             AlwaysStoppedAnimation(colors.primary),
        //                       )
        //                     : Icon(
        //                         CupertinoIcons.delete,
        //                       ),
        //               ),
        //             );
        //           },
        //         ),
        //       );
        //     }

        //     return const SizedBox.shrink();
        //   },
        // ),
      ],
    );
  }
}

class _PostImage extends StatelessWidget {
  final String imageUrl;

  const _PostImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${Constants.baseUrl}/files/$imageUrl",
      placeholder: (_, __) =>
          const SizedBox(height: 350, width: double.infinity),
      errorWidget: (_, __, ___) => const Icon(Icons.error),
      imageBuilder: (_, imageProvider) => Container(
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _PaddedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const _PaddedText(
    this.text, {
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
