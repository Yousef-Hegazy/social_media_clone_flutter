part of 'posts_cubit.dart';

// sealed class PostsState {}

// final class PostsInitial extends PostsState {}

// final class PostsLoading extends PostsState {}

// final class PostsLoaded extends PostsState {
//   final List<Post> posts;
//   final bool isLastPage;
//   final bool isFetching;

//   PostsLoaded(
//       {required this.posts, this.isLastPage = false, this.isFetching = false});
// }

// final class PostsError extends PostsState {
//   final String message;

//   PostsError(this.message);
// }

// final class PostCreated extends PostsState {
//   final Post post;

//   PostCreated(this.post);
// }

// final class PostCreationError extends PostsState {
//   final String message;

//   PostCreationError(this.message);
// }

// final class PostDeleting extends PostsLoaded {
//   PostDeleting({required super.posts, super.isLastPage, super.isFetching});
// }

// final class PostDeletionError extends PostsLoaded {
//   final String message;
//   PostDeletionError(
//     this.message, {
//     required super.posts,
//     super.isLastPage,
//     super.isFetching,
//   });
// }

class PostsState {
  final List<Post> posts;
  final bool isLoading;
  final bool isFetching;
  final bool isLastPage;
  final String? error;
  final Post? createdPost;
  final String? creationError;
  final String? deletionError;
  final bool? deletionSuccess;

  const PostsState({
    this.posts = const [],
    this.isLoading = false,
    this.isFetching = false,
    this.isLastPage = false,
    this.error,
    this.createdPost,
    this.creationError,
    this.deletionError,
    this.deletionSuccess,
  });

  PostsState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? isFetching,
    bool? isLastPage,
    String? error,
    Post? createdPost,
    String? creationError,
    String? deletionError,
    bool? deletionSuccess,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isFetching: isFetching ?? this.isFetching,
      isLastPage: isLastPage ?? this.isLastPage,
      error: error,
      createdPost: createdPost,
      creationError: creationError,
      deletionError: deletionError,
      deletionSuccess: deletionSuccess ?? false,
    );
  }

  factory PostsState.initial() => const PostsState();
}
