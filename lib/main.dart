import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/game_page.dart';
import 'package:minesweeper/models/prefs_manager.dart';
import 'package:minesweeper/start_page.dart';
import 'package:minesweeper/utils/analytics.dart';
import 'package:minesweeper/view_model/game_page_view_model.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => PrefsManager()),
        ChangeNotifierProvider(create: (context) => GamePageViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MineSweeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) {
          logScreenView(screenName: "Start");
          return const StartPage();
        },
        "/game": (context) {
          logScreenView(screenName: "Game");
          return const GamePage();
        },
      },
    );
  }
}
