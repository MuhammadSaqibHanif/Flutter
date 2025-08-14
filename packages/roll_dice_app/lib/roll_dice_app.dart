import 'package:flutter/material.dart';

import 'gradient_container.dart';

class RollDiceApp extends StatelessWidget {
  const RollDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: GradientContainer.purple(),
      body: GradientContainer(
        // colors: [
        //   Color.fromARGB(255, 81, 18, 229),
        //   Color.fromARGB(255, 45, 7, 98),
        // ],
        Color.fromARGB(255, 81, 18, 229),
        Color.fromARGB(255, 45, 7, 98),
      ),
    );
  }
}
