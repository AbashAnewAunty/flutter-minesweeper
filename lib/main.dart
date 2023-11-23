import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minesweeper/game_page.dart';
import 'package:minesweeper/repository/game_setting_repository.dart';
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

  /// 画面向き固定
  /// iPadのみ別途対応
  /// https://hiyoko-programming.com/1575/
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => PrefsManager()),
        ChangeNotifierProvider(
            create: (context) =>
                GameSettingRepository(prefsManager: context.read())),
        ChangeNotifierProvider(
          create: (context) =>
              StartPageViewModel(gameSettingRepository: context.read()),
        ),
        ChangeNotifierProxyProvider<GameSettingRepository, GamePageViewModel>(
          // create: (context) => GamePageViewModel(prefsManager: context.read()),
          create: (context) => GamePageViewModel(),
          update: (context, gameSettingRepository, gamePageViewModel) =>
              gamePageViewModel!..updateDifficulty(gameSettingRepository),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: "/home",
    routes: <RouteBase>[
      GoRoute(
        path: "/home",
        pageBuilder: (context, state) {
          logScreenView(screenName: "Start");
          return MaterialPage(
            key: state.pageKey,
            child: const StartPage(),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: "game",
            pageBuilder: (context, state) {
              logScreenView(screenName: "Game");
              return MaterialPage(
                key: state.pageKey,
                child: const GamePage(),
              );
            },
          ),
        ],
      ),
    ],
  );

  Future<void> init(BuildContext context) async {
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

        return MaterialApp.router(
          title: 'Flutter MineSweeper',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerConfig: _router,
          builder: (context, child) {
            return child!;
          },
        );
      },
    );
  }
}
