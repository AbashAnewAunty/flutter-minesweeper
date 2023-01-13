import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: () => viewModel.onTapTileAt(tileIndex),
      child: Selector<GamePageViewModel, bool>(
        selector: (context, viewModel) => viewModel.tiles[tileIndex].isOpen,
        builder: (context, isOpen, child) {
          return ColoredBox(
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
      return Colors.lightBlueAccent;
    }
  }
}
