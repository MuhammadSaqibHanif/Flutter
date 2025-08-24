import 'package:equatable/equatable.dart';
import '../../models/post.dart';

abstract class PostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Post> posts;
  final bool hasReachedMax;
  final String query;

  PostsLoaded({
    required this.posts,
    required this.hasReachedMax,
    this.query = '',
  });

  PostsLoaded copyWith({
    List<Post>? posts,
    bool? hasReachedMax,
    String? query,
  }) => PostsLoaded(
    posts: posts ?? this.posts,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    query: query ?? this.query,
  );

  @override
  List<Object?> get props => [posts, hasReachedMax, query];
}

class PostsError extends PostsState {
  final String error;
  PostsError({required this.error});
  @override
  List<Object?> get props => [error];
}
