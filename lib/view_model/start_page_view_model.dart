import 'package:flutter/cupertino.dart';
import 'package:minesweeper/constant.dart';

import '../repository/game_setting_repository.dart';

class StartPageViewModel extends ChangeNotifier {
  final GameSettingRepository gameSettingRepository;

  StartPageViewModel({required this.gameSettingRepository});

  Difficulty _difficulty = Difficulty.normal;

  Difficulty get difficulty => _difficulty;

  Future<void> setDifficulty(Difficulty difficulty) async {
    await gameSettingRepository.setDifficulty(difficulty);
  }

  Future<void> getDifficulty() async {
    await gameSettingRepository.getDifficulty();
    _difficulty = gameSettingRepository.difficulty;
  }
}
