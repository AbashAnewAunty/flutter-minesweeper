import 'package:flutter/material.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/game_dialog.dart';
import 'package:minesweeper/view_common/custom_long_press_gesture_detector.dart';
import 'package:minesweeper/view_model/game_page_view_model.dart';
import 'package:provider/provider.dart';

class GameTile extends StatelessWidget {
  final int tileIndex;

  const GameTile({
    super.key,
    required this.tileIndex,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<GamePageViewModel>();
    return CustomLongPressGestureDetector(
      onTap: () {
        viewModel.openTile(tileIndex);
        final state = viewModel.state;
        if (state == GameState.gameOver) {
          showDialog(
            context: context,
            builder: (context) => const GameOverDialog(),
          );
        } else if (state == GameState.gameClear) {
          showDialog(
            context: context,
            builder: (context) => const GameClearDialog(),
          );
        }
      },
      onLongPress: () => viewModel.toggleFlag(tileIndex),
      child: Selector<GamePageViewModel, bool>(
        selector: (context, viewModel) => viewModel.tiles[tileIndex].isOpen,
        builder: (context, isOpen, child) {
          return Selector<GamePageViewModel, bool>(
            selector: (context, viewModel) => viewModel.tiles[tileIndex].hasFlag,
            builder: (context, hasFlag, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  ColoredBox(
                    color: _getColor(
                      viewModel.tiles[tileIndex].isOpen,
                      viewModel.tiles[tileIndex].hasBomb,
                    ),
                    child: Center(
                      child: isOpen &&
                              !viewModel.tiles[tileIndex].hasBomb &&
                              viewModel.tiles[tileIndex].bombsAroundCount != 0
                          ? Text("${viewModel.tiles[tileIndex].bombsAroundCount}")
                          : null,
                    ),
                  ),
                  if (!viewModel.tiles[tileIndex].isOpen && viewModel.tiles[tileIndex].hasFlag)
                    const Icon(
                      Icons.flag_rounded,
                      color: Colors.white70,
                    )
                ],
              );
            },
          );
        },
      ),
    );
  }

  Color _getColor(bool isOpen, bool hasBomb) {
    if (!isOpen) {
      return Colors.blueGrey;
    }
    if (hasBomb) {
      return Colors.red;
    } else {
      return Colors.grey.withAlpha(128);
    }
  }
}
