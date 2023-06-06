import 'package:flutter/material.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/manager/prefs_manager.dart';

class GameSettingRepository extends ChangeNotifier {
  final PrefsManager prefsManager;
  Difficulty _difficulty = Difficulty.normal;

  Difficulty get difficulty => _difficulty;

  GameSettingRepository({required this.prefsManager});

  Future<void> setDifficulty(Difficulty difficulty) async {
    _difficulty = difficulty;
    await prefsManager.setDifficulty(difficulty);
    notifyListeners();
  }

  Future<void> getDifficulty() async {
    _difficulty = await prefsManager.getDifficulty();
    notifyListeners();
  }
}
