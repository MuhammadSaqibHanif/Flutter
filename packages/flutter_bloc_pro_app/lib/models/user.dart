import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String token;

  const User({required this.id, required this.username, required this.token});

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'token': token,
  };
  static User fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    username: json['username'] as String,
    token: json['token'] as String,
  );

  @override
  List<Object?> get props => [id, username, token];
}
