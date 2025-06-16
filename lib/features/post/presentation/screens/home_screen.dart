import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/features/post/presentation/cubit/posts_cubit.dart';
import 'package:social_media_clean/features/post/presentation/screens/create_post_screen.dart';
import 'package:social_media_clean/features/post/presentation/widgets/home_drawer.dart';
import 'package:social_media_clean/features/post/presentation/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      context.read<PostsCubit>().fetchInitialPosts();
      _initialized = true;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 150) {
      context.read<PostsCubit>().fetchMorePosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text("Home"),
  //         centerTitle: true,
  //         actions: [
  //           IconButton(
  //             icon: const Icon(Icons.add_rounded),
  //             tooltip: "Create Post",
  //             onPressed: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const CreatePostScreen(),
  //               ),
  //             ),
  //           ),
  //           BlocBuilder<PostsCubit, PostsState>(
  //             builder: (context, state) {
  //               return IconButton(
  //                 icon: SizedBox(
  //                   width: 20,
  //                   height: 20,
  //                   child: state is PostsLoading
  //                       ? CircularProgressIndicator.adaptive(
  //                           valueColor: AlwaysStoppedAnimation(_colors.primary),
  //                         )
  //                       : Icon(Icons.refresh_rounded),
  //                 ),
  //                 tooltip: "Refresh",
  //                 onPressed: state is PostsLoading
  //                     ? null
  //                     : () => context.read<PostsCubit>().fetchInitialPosts(),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //       drawer: HomeDrawer(),
  //       body: RefreshIndicator(
  //         onRefresh: () => context.read<PostsCubit>().fetchInitialPosts(),
  //         child: BlocBuilder<PostsCubit, PostsState>(builder: (context, state) {
  //           switch (state) {
  //             case PostsError(:final message):
  //               return Center(
  //                 child: Text(message),
  //               );
  //             case PostsLoading():
  //               return Center(
  //                 child: CircularProgressIndicator.adaptive(
  //                   valueColor: AlwaysStoppedAnimation(_colors.primary),
  //                 ),
  //               );
  //             case PostsLoaded(
  //                 :final posts,
  //                 :final isFetching,
  //                 :final isLastPage
  //               ):
  //               return ListView.builder(
  //                 controller: _scrollController,
  //                 itemCount: posts.length + (isFetching && !isLastPage ? 1 : 0),
  //                 itemBuilder: (context, index) {
  //                   if (index >= posts.length && isFetching && !isLastPage) {
  //                     return const Padding(
  //                       padding: EdgeInsets.all(8.0),
  //                       child:
  //                           Center(child: CircularProgressIndicator.adaptive()),
  //                     );
  //                   }

  //                   return PostCard(post: posts[index]);
  //                 },
  //               );
  //             default:
  //               return const SizedBox(
  //                 height: 100,
  //               );
  //           }
  //         }),
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          _CreatePostButton(),
          _RefreshButton(colors: colors),
        ],
      ),
      drawer: const HomeDrawer(),
      body: RefreshIndicator(
        onRefresh: postsCubit.fetchInitialPosts,
        child: BlocBuilder<PostsCubit, PostsState>(
          builder: (context, state) {
            if (state.error != null) {
              return Center(child: Text(state.error!));
            }

            if (state.isLoading && state.posts.isEmpty) {
              return Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(colors.primary),
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: state.posts.length +
                  (state.isFetching && !state.isLastPage ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }

                return PostCard(post: state.posts[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _CreatePostButton extends StatelessWidget {
  const _CreatePostButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_rounded),
      tooltip: "Create Post",
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreatePostScreen(),
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final ColorScheme colors;

  const _RefreshButton({required this.colors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return IconButton(
          tooltip: "Refresh",
          onPressed: state.isLoading
              ? null
              : () => context.read<PostsCubit>().fetchInitialPosts(),
          icon: SizedBox(
            width: 20,
            height: 20,
            child: state.isLoading
                ? CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(colors.primary),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
        );
      },
    );
  }
}
