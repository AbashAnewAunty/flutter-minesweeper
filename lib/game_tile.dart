import 'package:flutter/material.dart';
import 'package:minesweeper/view_model/game_page_view_model.dart';
import 'package:provider/provider.dart';

class GameTile extends StatelessWidget {
  final int tileIndex;
  final int neighborBombsCount;

  const GameTile({
    super.key,
    required this.tileIndex,
    this.neighborBombsCount = 0,
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
                      _existsBombsAround &&
                      !viewModel.tiles[tileIndex].hasBomb
                  ? Text("$neighborBombsCount")
                  : null,
            ),
          );
        },
      ),
    );
  }

  bool get _existsBombsAround => neighborBombsCount != 0;

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
