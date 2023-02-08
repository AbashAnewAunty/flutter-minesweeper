import 'package:flutter/material.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/utils/analytics.dart';
import 'package:minesweeper/view_model/game_page_view_model.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'game_tile.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

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
              _tempAppbar(context),
              Expanded(
                child: Center(
                  child: Selector<GamePageViewModel,
                      Tuple2<GameState, Difficulty>>(
                    selector: (context, viewModel) =>
                        Tuple2(viewModel.state, viewModel.difficulty),
                    shouldRebuild: (oldState, newState) {
                      if (oldState == GameState.isPlaying &&
                          newState == GameState.beforeGame) {
                        viewModel.reset();
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state, child) {
                      return GridView.count(
                        crossAxisCount: viewModel.tileColumnCount,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 20,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        children: List.generate(
                          viewModel.tileCount,
                          (index) => GameTile(tileIndex: index),
                        ),
                      );
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => viewModel.reset(),
                child: const Text("reset"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tempAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: GestureDetector(
        onTap: () {
          logScreenView(screenName: "Start");
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flag),
          const SizedBox(width: 5),
          Selector<GamePageViewModel, int>(
            selector: (context, viewModel) => viewModel.flagCount,
            builder: (context, flagCount, child) {
              return Text("$flagCount");
            },
          ),
          const SizedBox(width: 10),
          const Icon(Icons.access_time),
          const SizedBox(width: 5),
          Selector<GamePageViewModel, Duration>(
            selector: (context, viewModel) => viewModel.now,
            builder: (context, elapsed, child) {
              return Text(
                  "${elapsed.inHours}:${(elapsed.inMinutes % 60).toString().padLeft(2, "0")}:${(elapsed.inSeconds % 60).toString().padLeft(2, "0")}");
            },
          ),
        ],
      ),
    );
  }
}
