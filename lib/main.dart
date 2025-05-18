import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:master_app/features/quiz_app/quiz_app.dart';
import 'package:master_app/features/todo_app/todo_app.dart';
import 'package:master_app/features/meals_app/meals_app.dart';
import 'package:master_app/features/roll_dice_app/roll_dice_app.dart';
import 'package:master_app/features/expense_tracker_app/expense_tracker_app.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]).then((fn) {
  // runApp();
  // });
  runApp(const MyApp());
}

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter Learning Apps',
      // theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 16,
          ),
        ),
      ),
      // themeMode: ThemeMode.system, // default
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: const MyHomePage(),
    );
  }
}

const apps = [
  {'name': 'Roll Dice App', 'icon': '🎲', 'widget': RollDiceApp()},
  {'name': 'Quiz App', 'icon': '❓', 'widget': QuizApp()},
  {'name': 'Expense Tracker App', 'icon': '🧮', 'widget': ExpenseTrackerApp()},
  {'name': 'Todo App', 'icon': '☁️', 'widget': TodoApp()},
  {'name': 'Meals App', 'icon': '❓', 'widget': MealsApp()},
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
              leading: Text(
                app['icon'] as String,
                style: TextStyle(fontSize: 28),
              ),
              title: Text(
                app['name'] as String,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to the respective app
                // Navigator.push(context, MaterialPageRoute(builder: (_) => TodoApp()));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => app['widget'] as Widget),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
