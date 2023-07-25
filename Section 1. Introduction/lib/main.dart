import 'package:flutter/material.dart';

import 'package:first_app/gradient_container.dart';

main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        // body: GradientContainer.purple(),
        body: GradientContainer(
          // colors: [
          //   Color.fromARGB(255, 81, 18, 229),
          //   Color.fromARGB(255, 45, 7, 98),
          // ],
          const Color.fromARGB(255, 81, 18, 229),
          const Color.fromARGB(255, 45, 7, 98),
        ),
      ),
    ),
  );
}
