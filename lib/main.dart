import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/game_page.dart';
import 'package:minesweeper/start_page.dart';
import 'package:minesweeper/utils/analytics.dart';
import 'package:minesweeper/view_model/game_page_view_model.dart';
import 'package:minesweeper/view_model/start_page_view_model.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'manager/prefs_manager.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => PrefsManager()),
        ChangeNotifierProvider(
          create: (context) => StartPageViewModel(prefsManager: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => GamePageViewModel(prefsManager: context.read()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future init(BuildContext context) async {
    final prefsManager = context.read<PrefsManager>();
    final startPageViewModel = context.read<StartPageViewModel>();
    await prefsManager.init();
    await startPageViewModel.getDifficulty();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

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
      },
    );
  }
}
