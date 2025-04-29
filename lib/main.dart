import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter Learning Apps',
      // theme: ThemeData(primarySwatch: Colors.blue),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

final List<Map<String, String>> apps = [
  {'name': 'Todo App', 'icon': '📝'},
  {'name': 'Calculator App', 'icon': '🧮'},
  {'name': 'Notes App', 'icon': '📘'},
  {'name': 'Weather App', 'icon': '☁️'},
  {'name': 'Quiz App', 'icon': '❓'},
];

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Learning Apps')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Text(app['icon']!, style: TextStyle(fontSize: 28)),
              title: Text(
                app['name']!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to the respective app
                // Navigator.push(context, MaterialPageRoute(builder: (_) => TodoApp()));
              },
            ),
          );
        },
      ),
    );
  }
}
