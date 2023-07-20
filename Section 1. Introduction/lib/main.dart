import 'package:flutter/material.dart';

import 'package:first_app/gradient_container.dart';

main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: GradientContainer(
          // colors: [
          //   Color.fromARGB(255, 81, 18, 229),
          //   Color.fromARGB(255, 45, 7, 98),
          // ],
          Color.fromARGB(255, 81, 18, 229),
          Color.fromARGB(255, 45, 7, 98),
        ),
      ),
    ),
  );
}
