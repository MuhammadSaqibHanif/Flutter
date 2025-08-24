import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/post.dart';
import '../blocs/posts/posts_bloc.dart';
import '../blocs/posts/posts_event.dart';
import '../blocs/posts/posts_state.dart';

class PostListItem extends StatelessWidget {
  final Post post;
  const PostListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap:
            () =>
                Navigator.of(context).pushNamed('/postDetail', arguments: post),

        // BlocSelector ensures only this trailing widget rebuilds on like changes
        trailing: BlocSelector<PostsBloc, PostsState, Post?>(
          selector: (state) {
            if (state is PostsLoaded) {
              // Find the updated post in the state by ID
              return state.posts.firstWhere(
                (p) => p.id == post.id,
                orElse: () => post, // fallback to original
              );
            }
            return post; // fallback while loading
          },
          builder: (context, selectedPost) {
            final currentPost = selectedPost ?? post;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${currentPost.likes}'),
                IconButton(
                  icon: Icon(
                    currentPost.likedByUser
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () {
                    context.read<PostsBloc>().add(
                      ToggleLikePost(postId: currentPost.id),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
