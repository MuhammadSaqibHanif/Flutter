import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String title;
  final String body;
  final int likes;
  final bool likedByUser;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.likes,
    required this.likedByUser,
  });

  Post copyWith({
    String? id,
    String? title,
    String? body,
    int? likes,
    bool? likedByUser,
  }) => Post(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    likes: likes ?? this.likes,
    likedByUser: likedByUser ?? this.likedByUser,
  );

  @override
  List<Object?> get props => [id, title, body, likes, likedByUser];
}
