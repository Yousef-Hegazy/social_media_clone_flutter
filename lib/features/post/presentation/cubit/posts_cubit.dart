import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clean/features/post/domain/entities/post.dart';
import 'package:social_media_clean/features/post/domain/usecases/create_post_usecase.dart';
import 'package:social_media_clean/features/post/domain/usecases/delete_post_usecase.dart';
import 'package:social_media_clean/features/post/domain/usecases/get_posts_usecase.dart';

part 'posts_state.dart';

// class PostsCubit extends Cubit<PostsState> {
//   final GetPostsUsecase _getPostsUsecase;
//   final CreatePostUsecase _createPostUsecase;
//   final DeletePostUsecase _deletePostUsecase;

//   int _page = 1;
//   int _pageSize = 10;
//   bool _isFetching = false;
//   bool _isLastPage = false;
//   final List<Post> _allPosts = [];

//   List<Post> get allPosts => _allPosts;
//   bool get isFetching => _isFetching;
//   bool get isLastPage => _isLastPage;
//   int get page => _page;
//   int get pageSize => _pageSize;

//   PostsCubit(
//     this._getPostsUsecase,
//     this._createPostUsecase,
//     this._deletePostUsecase,
//   ) : super(PostsInitial());

//   Future<void> fetchInitialPosts() async {
//     _page = 1;
//     _pageSize = 10;
//     _allPosts.clear();
//     _isLastPage = false;

//     emit(PostsLoading());

//     await _fetchPosts();
//   }

//   Future<void> fetchMorePosts() async {
//     _page++;

//     await _fetchPosts();
//   }

//   Future<void> _fetchPosts() async {
//     if (_isFetching || _isLastPage) return;

//     _isFetching = true;

//     if (_allPosts.isNotEmpty) {
//       emit(PostsLoaded(
//           posts: _allPosts, isFetching: _isFetching, isLastPage: _isLastPage));
//     }

//     final res = await _getPostsUsecase(
//       page: _page,
//       pageSize: _pageSize,
//     );

//     res.fold((e) {
//       _isFetching = false;
//       emit(PostsError(e.message));
//     }, (pagedRes) {
//       _isLastPage = pagedRes.last;
//       _allPosts.addAll(pagedRes.content);
//       _isFetching = false;
//       emit(PostsLoaded(
//           posts: _allPosts, isFetching: _isFetching, isLastPage: _isLastPage));
//     });
//   }

//   Future<void> createPost({required String text, required File image}) {
//     emit(PostsLoading());

//     return _createPostUsecase(text: text, image: image).then((result) {
//       result.fold(
//         (failure) => emit(PostCreationError(failure.message)),
//         (post) => emit(PostCreated(post)),
//       );
//     });
//   }

//   Future<void> deletePost(String id) async {
//     emit(
//       PostDeleting(posts: _allPosts, isLastPage: _isLastPage, isFetching: true),
//     );

//     final res = await _deletePostUsecase(id: id);

//     res.fold(
//       (e) => emit(PostDeletionError(e.message,
//           posts: _allPosts, isFetching: false, isLastPage: _isLastPage)),
//       (_) => emit(
//         PostsLoaded(
//             posts: _allPosts, isLastPage: _isLastPage, isFetching: false),
//       ),
//     );
//   }
// }

class PostsCubit extends Cubit<PostsState> {
  final GetPostsUsecase _getPostsUsecase;
  final CreatePostUsecase _createPostUsecase;
  final DeletePostUsecase _deletePostUsecase;

  int _page = 1;
  final int _pageSize = 10;

  PostsCubit(
    this._getPostsUsecase,
    this._createPostUsecase,
    this._deletePostUsecase,
  ) : super(PostsState.initial());

  Future<void> fetchInitialPosts() async {
    _page = 1;
    emit(state.copyWith(
      isLoading: true,
      posts: [],
      error: null,
      createdPost: null,
      creationError: null,
      deletionError: null,
      isLastPage: false,
      isFetching: false,
    ));
    await _fetchPosts();
  }

  Future<void> fetchMorePosts() async {
    if (state.isFetching || state.isLastPage) return;
    _page++;
    await _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    emit(state.copyWith(isFetching: true, error: null));
    final result = await _getPostsUsecase(page: _page, pageSize: _pageSize);

    result.fold(
      (failure) => emit(
        state.copyWith(isFetching: false, error: failure.message),
      ),
      (paged) {
        final updatedPosts = [...state.posts, ...paged.content];
        emit(state.copyWith(
          posts: updatedPosts,
          isFetching: false,
          isLastPage: paged.last,
          isLoading: false,
          error: null,
          createdPost: null,
          creationError: null,
          deletionError: null,
        ));
      },
    );
  }

  Future<void> createPost({required String text, required File image}) async {
    emit(state.copyWith(
        isLoading: true, creationError: null, createdPost: null));
    final result = await _createPostUsecase(text: text, image: image);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, creationError: failure.message),
      ),
      (post) => emit(
        state.copyWith(isLoading: false, createdPost: post),
      ),
    );
  }

  Future<void> deletePost(String id) async {
    emit(state.copyWith(isFetching: true, deletionError: null));
    final result = await _deletePostUsecase(id: id);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isFetching: false,
            deletionError: failure.message.toString(),
            deletionSuccess: false,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
              isFetching: false, deletionError: null, deletionSuccess: true),
        );

        fetchInitialPosts();
      },
    );
  }

  void clearFlags() {
    emit(state.copyWith(
      isLoading: false,
      isFetching: false,
      error: null,
      createdPost: null,
      creationError: null,
      deletionError: null,
    ));
  }
}
