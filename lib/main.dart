import 'package:flame/game.dart';
import 'package:flappygame/database/database.dart';
import 'package:flappygame/game.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.database;

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppDatabase.instance,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flappy Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GameWidget(game: FlappyGame()),
    );
  }
}
