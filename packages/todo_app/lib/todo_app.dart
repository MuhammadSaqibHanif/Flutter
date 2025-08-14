import 'package:flutter/material.dart';

// import 'package:flutter_internals/ui_updates_demo.dart';
import './keys/keys.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Internals')),
      body: const Keys(),
    );
  }
}
