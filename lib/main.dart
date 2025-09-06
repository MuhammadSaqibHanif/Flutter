import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:quiz_app/quiz_app.dart';
import 'package:chat_app/chat_app.dart';
import 'package:todo_app/todo_app.dart';
import 'package:meals_app/meals_app.dart';
import 'package:roll_dice_app/roll_dice_app.dart';
import 'package:shopping_list_app/shopping_list_app.dart';
import 'package:favorite_places_app/favorite_places_app.dart';
import 'package:expense_tracker_app/expense_tracker_app.dart';
import 'package:flutter_bloc_pro_app/flutter_bloc_pro_app.dart';
import 'package:flutter_advanced_topics_mastery_app/flutter_advanced_topics_mastery_app.dart';

import 'package:chat_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]).then((fn) {
  // runApp();
  // });

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

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
  {'name': 'Quiz App', 'icon': '🧠', 'widget': QuizApp()},
  {'name': 'Expense Tracker App', 'icon': '💰', 'widget': ExpenseTrackerApp()},
  {'name': 'Todo App', 'icon': '📝', 'widget': TodoApp()},
  {'name': 'Meals App', 'icon': '🍽️', 'widget': MealsApp()},
  {'name': 'Shopping List App', 'icon': '🛒', 'widget': ShoppingListApp()},
  {'name': 'Favorite Places App', 'icon': '📍', 'widget': FavoritePlacesApp()},
  {'name': 'Chat App', 'icon': '💬', 'widget': ChatApp()},
  {'name': 'Bloc Mastery App', 'icon': '🧩', 'widget': FlutterBlocProApp()},
  {
    'name': 'Flutter Advanced Topics Mastery App',
    'icon': '🧩',
    'widget': FlutterAdvancedTopicsMasteryApp(),
  },
];

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learning Apps')),
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
