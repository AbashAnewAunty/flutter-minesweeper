import 'package:flutter_test/flutter_test.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/repository/game_setting_repository.dart';
import 'package:minesweeper/view_model/game_page_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_page_view_model.mocks.dart';

@GenerateMocks([GameSettingRepository])
void main() {
  test('難易度設定　easy', () {
    final mockGameSettingRepository = MockGameSettingRepository();
    when(mockGameSettingRepository.difficulty).thenReturn(Difficulty.easy);

    /// set up
    final gamePageViewModel = GamePageViewModel();

    /// do something
    gamePageViewModel.updateDifficulty(mockGameSettingRepository);

    /// test
    expect(gamePageViewModel.bombCount, 10);
    expect(gamePageViewModel.tileColumnCount, 10);
    expect(gamePageViewModel.tileRowCount, 10);
  });
}
