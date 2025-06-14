import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media_clean/core/utils/constants.dart';
import 'package:social_media_clean/features/post/presentation/cubit/posts_cubit.dart';
import 'package:social_media_clean/features/post/presentation/screens/create_post_screen.dart';
import 'package:social_media_clean/features/post/presentation/widgets/home_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<PostsCubit>(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ScrollController _scrollController;
  late final ColorScheme _colors;
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
      _colors = Theme.of(context).colorScheme;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: "Create Post",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreatePostScreen(),
                ),
              ),
            ),
          ],
        ),
        drawer: HomeDrawer(),
        body: RefreshIndicator(
          onRefresh: () => context.read<PostsCubit>().fetchInitialPosts(),
          child: BlocBuilder<PostsCubit, PostsState>(builder: (context, state) {
            switch (state) {
              case PostsError(:final message):
                return Center(
                  child: Text(message),
                );
              case PostsLoading():
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(_colors.primary),
                  ),
                );
              case PostsLoaded(
                  :final posts,
                  :final isFetching,
                  :final isLastPage
                ):
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: posts.length + (isFetching && !isLastPage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= posts.length && isFetching && !isLastPage) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Center(child: CircularProgressIndicator.adaptive()),
                      );
                    }

                    final post = posts[index];

                    return Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              "${Constants.baseUrl}/files/${post.imageUrl}",
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageBuilder: (ctx, imageProvider) => Container(
                            height: 430,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.username,
                          style: TextStyle(
                            color: _colors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.text,
                          maxLines: 1,
                        ),
                      ],
                    );
                  },
                );
              default:
                return const SizedBox(
                  height: 100,
                );
            }
          }),
        ));
  }
}
