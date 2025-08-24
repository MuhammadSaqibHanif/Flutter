import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostsEvent {}

class RefreshPosts extends PostsEvent {}

class SearchPosts extends PostsEvent {
  final String query;
  SearchPosts(this.query);
  @override
  List<Object?> get props => [query];
}

class ToggleLikePost extends PostsEvent {
  final String postId;
  ToggleLikePost({required this.postId});
  @override
  List<Object?> get props => [postId];
}
