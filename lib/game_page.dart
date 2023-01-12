import 'package:flutter/material.dart';
import 'package:minesweeper/view_model/game_page_view_model.dart';
import 'package:provider/provider.dart';

import 'game_tile.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<GamePageViewModel>();
    viewModel.generateRandomList();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<GamePageViewModel>();
    return Material(
      color: Colors.blueGrey,
      child: SafeArea(
        child: Container(
          color: Colors.grey,
          child: Column(
            children: [
              _tempAppbar(),
              Expanded(
                child: Center(
                  child: GridView.count(
                    crossAxisCount: viewModel.tileColumnCount,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    children: List.generate(
                      viewModel.tiles.length,
                      (index) {
                        final int neighborBombsCount =
                            viewModel.calculateBombsAroundCount(index);
                        return GameTile(
                          tile: viewModel.tiles[index],
                          neighborBombsCount: neighborBombsCount,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tempAppbar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 20,
            child: Icon(Icons.lock_clock),
          ),
          SizedBox(width: 10),
          Text("00:10:99"),
          SizedBox(width: 60),
        ],
      ),
    );
  }
}
