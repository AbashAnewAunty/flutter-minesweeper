import 'package:flutter/cupertino.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/manager/prefs_manager.dart';

class StartPageViewModel extends ChangeNotifier {
  late final PrefsManager _presManager;

  StartPageViewModel({required PrefsManager prefsManager}) {
    _presManager = prefsManager;
  }

  Difficulty difficulty = Difficulty.normal;

  Future setDifficulty(Difficulty difficulty) async {
    await _presManager.setDifficulty(difficulty);
  }

  Future getDifficulty() async {
    difficulty = await _presManager.getDifficulty();
  }
}
