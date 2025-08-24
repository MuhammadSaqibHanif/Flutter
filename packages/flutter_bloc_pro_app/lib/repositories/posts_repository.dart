import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/post.dart';

class PostsRepository {
  // Simulated backend store
  final List<Post> _store = List.generate(
    42,
    (i) => Post(
      id: Uuid().v4(),
      title: 'Post #$i',
      body: 'This is the body for post #$i. It has some meaningful content.',
      likes: i % 7,
      likedByUser: false,
    ),
  );

  Future<List<Post>> fetchPosts({
    required int page,
    required int limit,
    String query = "",
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final filtered =
        query.isEmpty
            ? _store
            : _store
                .where(
                  (p) =>
                      p.title.toLowerCase().contains(query.toLowerCase()) ||
                      p.body.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

    final start = (page - 1) * limit;
    if (start >= filtered.length) return [];
    final end =
        (start + limit) > filtered.length ? filtered.length : (start + limit);
    return filtered.sublist(start, end);
  }

  Future<Post> toggleLike(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _store.indexWhere((p) => p.id == postId);
    if (idx == -1) throw Exception('Post not found');
    final existing = _store[idx];
    final updated = existing.copyWith(
      likedByUser: !existing.likedByUser,
      likes: existing.likedByUser ? existing.likes - 1 : existing.likes + 1,
    );
    _store[idx] = updated;
    return updated;
  }
}
