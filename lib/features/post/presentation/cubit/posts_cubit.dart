import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/features/post/domain/entities/post.dart';
import 'package:social_media_clean/features/post/domain/usecases/create_post_usecase.dart';
import 'package:social_media_clean/features/post/domain/usecases/get_posts_usecase.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final GetPostsUsecase _getPostsUsecase;
  final CreatePostUsecase _createPostUsecase;

  int _page = 1;
  int _pageSize = 10;
  bool _isFetching = false;
  bool _isLastPage = false;
  final List<Post> _allPosts = [];

  List<Post> get allPosts => _allPosts;
  bool get isFetching => _isFetching;
  bool get isLastPage => _isLastPage;
  int get page => _page;
  int get pageSize => _pageSize;

  PostsCubit(this._getPostsUsecase, this._createPostUsecase)
      : super(PostsInitial());

  Future<void> fetchInitialPosts() async {
    _page = 1;
    _pageSize = 10;
    _allPosts.clear();
    _isLastPage = false;

    emit(PostsLoading());

    await _fetchPosts();
  }

  Future<void> fetchMorePosts() async {
    _page++;

    await _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    if (_isFetching || _isLastPage) return;

    _isFetching = true;

    if (_allPosts.isNotEmpty) {
      emit(PostsLoaded(_allPosts,
          isFetching: _isFetching, isLastPage: _isLastPage));
    }

    final res = await _getPostsUsecase(
      page: _page,
      pageSize: _pageSize,
    );

    res.fold((e) {
      _isFetching = false;
      emit(PostsError(e.message));
    }, (pagedRes) {
      _isLastPage = pagedRes.last;
      _allPosts.addAll(pagedRes.content);
      _isFetching = false;
      emit(PostsLoaded(_allPosts,
          isFetching: _isFetching, isLastPage: _isLastPage));
    });
  }

  Future<void> createPost({required String text, required File image}) {
    emit(PostsLoading());

    return _createPostUsecase(text: text, image: image).then((result) {
      result.fold(
        (failure) => emit(PostCreationError(failure.message)),
        (post) => emit(PostCreated(post)),
      );
    });
  }
}
