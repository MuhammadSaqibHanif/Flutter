import 'package:flutter/material.dart';

class InfiniteList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext, int) itemBuilder;
  final VoidCallback onEndReached;
  final Future<void> Function()? onRefresh;
  final bool hasReachedMax;

  const InfiniteList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onEndReached,
    this.onRefresh,
    this.hasReachedMax = false,
  });

  @override
  _InfiniteListState<T> createState() => _InfiniteListState<T>();
}

class _InfiniteListState<T> extends State<InfiniteList<T>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !widget.hasReachedMax) {
        widget.onEndReached();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView.builder(
        controller: _scrollController,
        itemCount:
            widget.hasReachedMax
                ? widget.items.length
                : widget.items.length + 1,
        itemBuilder: (context, index) {
          if (index >= widget.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return widget.itemBuilder(context, index);
        },
      ),
    );
  }
}
