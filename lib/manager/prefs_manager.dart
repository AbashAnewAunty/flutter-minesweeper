import 'package:minesweeper/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  /// 初期化完了フラグ
  bool _completedInitialization = false;

  late final SharedPreferences _prefs;

  Future init() async {
    if (_completedInitialization) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
    _completedInitialization = true;
  }

  Future setDifficulty(Difficulty difficulty) async {
    await _prefs.setInt("difficulty", difficulty.index);
  }

  Future<Difficulty> getDifficulty() async {
    final int enumIndex = _prefs.getInt("difficulty") ?? 1;
    return Difficulty.values.elementAt(enumIndex);
  }
}
