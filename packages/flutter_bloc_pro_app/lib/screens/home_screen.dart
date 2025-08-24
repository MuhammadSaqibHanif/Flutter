import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/infinite_list.dart';
import '../widgets/post_list_item.dart';
import '../blocs/posts/posts_bloc.dart';
import '../blocs/posts/posts_event.dart';
import '../blocs/posts/posts_state.dart';
import '../repositories/posts_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
    // RepositoryProvider.value(
    //   value: RepositoryProvider.of<PostsRepository>(context),
    //   child:
    BlocProvider(
      create:
          (context) => PostsBloc(
            postsRepository: RepositoryProvider.of<PostsRepository>(context),
          )..add(FetchPosts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Feed'),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/search'),
              icon: const Icon(Icons.search),
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed:
                    () => context.read<AuthBloc>().add(LogoutRequested()),
              ),
            ),
          ],
        ),
        body: const PostsWidget(),
      ),
      // ),
    );
  }
}

class PostsWidget extends StatefulWidget {
  const PostsWidget({super.key});

  @override
  State<PostsWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final query = _searchController.text.trim();
      context.read<PostsBloc>().add(SearchPosts(query));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    context.read<PostsBloc>().add(SearchPosts(query));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: "Search posts...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocConsumer<PostsBloc, PostsState>(
            listener: (context, state) {
              if (state is PostsError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              if (state is PostsLoading && state is! PostsLoaded) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostsError) {
                return Center(child: Text("Error: ${state.error}"));
              } else if (state is PostsInitial || state is PostsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PostsLoaded) {
                if (state.posts.isEmpty) {
                  return const Center(child: Text("No posts found"));
                }
                return InfiniteList(
                  items: state.posts,
                  hasReachedMax: state.hasReachedMax,
                  onEndReached:
                      () => context.read<PostsBloc>().add(FetchPosts()),
                  onRefresh: () async {
                    context.read<PostsBloc>().add(RefreshPosts());
                  },
                  itemBuilder:
                      (context, index) =>
                          PostListItem(post: state.posts[index]),
                );
              }
              return const Center(child: Text('No posts'));
            },
          ),
        ),
      ],
    );
  }
}
