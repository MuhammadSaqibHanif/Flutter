import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'posts_event.dart';
import 'posts_state.dart';
import '../../repositories/posts_repository.dart';
import '../../models/post.dart';

const _postLimit = 10;

// Debounce for search
// For example: Wait until you stop talking, then answer your last question.
EventTransformer<E> restartableDebounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

// For example: Answer the first question you ask, then ignore you until I’m done.
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;

  int _page = 1;
  String _searchQuery = "";

  PostsBloc({required this.postsRepository}) : super(PostsInitial()) {
    on<FetchPosts>(
      _onFetchPosts,
      transformer: throttleDroppable(const Duration(milliseconds: 300)),
    );
    on<RefreshPosts>(_onRefreshPosts);
    on<SearchPosts>(
      _onSearchPosts,
      transformer: restartableDebounce(const Duration(milliseconds: 400)),
    );
    on<ToggleLikePost>(_onToggleLikePost);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
    final currentState = state;
    try {
      if (currentState is PostsInitial) {
        emit(PostsLoading());
        _page = 1;
        final posts = await postsRepository.fetchPosts(
          page: _page,
          limit: _postLimit,
          query: _searchQuery,
        );
        emit(
          PostsLoaded(
            posts: posts,
            hasReachedMax: posts.length < _postLimit,
            query: _searchQuery,
          ),
        );
        return;
      }

      if (currentState is PostsLoaded && !currentState.hasReachedMax) {
        _page += 1;
        final posts = await postsRepository.fetchPosts(
          page: _page,
          limit: _postLimit,
          query: _searchQuery,
        );
        final hasReachedMax = posts.isEmpty || posts.length < _postLimit;
        emit(
          currentState.copyWith(
            posts: List.of(currentState.posts)..addAll(posts),
            hasReachedMax: hasReachedMax,
          ),
        );
      }
    } catch (e) {
      emit(PostsError(error: e.toString()));
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPosts event,
    Emitter<PostsState> emit,
  ) async {
    try {
      _page = 1;
      final posts = await postsRepository.fetchPosts(
        page: _page,
        limit: _postLimit,
        query: _searchQuery,
      );
      emit(
        PostsLoaded(
          posts: posts,
          hasReachedMax: posts.length < _postLimit,
          query: _searchQuery,
        ),
      );
    } catch (e) {
      emit(PostsError(error: e.toString()));
    }
  }

  Future<void> _onSearchPosts(
    SearchPosts event,
    Emitter<PostsState> emit,
  ) async {
    _searchQuery = event.query;
    _page = 1;

    emit(PostsLoading());
    try {
      final posts = await postsRepository.fetchPosts(
        page: _page,
        limit: _postLimit,
        query: _searchQuery,
      );
      emit(
        PostsLoaded(
          posts: posts,
          hasReachedMax: posts.length < _postLimit,
          query: _searchQuery,
        ),
      );
    } catch (e) {
      emit(PostsError(error: e.toString()));
    }
  }

  Future<void> _onToggleLikePost(
    ToggleLikePost event,
    Emitter<PostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PostsLoaded) return;

    final posts = currentState.posts;
    final idx = posts.indexWhere((p) => p.id == event.postId);
    if (idx == -1) return;

    final original = posts[idx];
    final optimistic = original.copyWith(
      likedByUser: !original.likedByUser,
      likes: original.likedByUser ? original.likes - 1 : original.likes + 1,
    );

    // emit optimistic update
    final updatedPosts = List<Post>.from(posts)..[idx] = optimistic;
    emit(currentState.copyWith(posts: updatedPosts));

    try {
      final confirmed = await postsRepository.toggleLike(event.postId);
      final confirmedPosts = List<Post>.from(updatedPosts)..[idx] = confirmed;
      emit(currentState.copyWith(posts: confirmedPosts));
    } catch (e) {
      // revert on failure
      final revertedPosts = List<Post>.from(updatedPosts)..[idx] = original;
      emit(currentState.copyWith(posts: revertedPosts));
    }
  }
}
