part of 'posts_cubit.dart';

sealed class PostsState {}

final class PostsInitial extends PostsState {}

final class PostsLoading extends PostsState {}

final class PostsLoaded extends PostsState {
  final List<Post> posts;
  final bool isLastPage;
  final bool isFetching;

  PostsLoaded(this.posts, {this.isLastPage = false, this.isFetching = false});
}

final class PostsError extends PostsState {
  final String message;

  PostsError(this.message);
}

final class PostCreated extends PostsState {
  final Post post;

  PostCreated(this.post);
}

final class PostCreationError extends PostsState {
  final String message;

  PostCreationError(this.message);
}
