import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/view_model/game_page_view_model.dart';
import 'package:minesweeper/view_model/start_page_view_model.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late final GroupButtonController _groupButtonController;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<StartPageViewModel>();
    _groupButtonController =
        GroupButtonController(selectedIndex: viewModel.difficulty.index);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueGrey,
      child: SafeArea(
        child: ColoredBox(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Minesweeper"),
              const SizedBox(height: 10),
              _quickPlayButton(context),
              const SizedBox(height: 20),
              GroupButton(
                buttons: const ["easy", "normal", "hard"],
                controller: _groupButtonController,
                onSelected: (text, index, isSelected) async {
                  final startPageViewModel = context.read<StartPageViewModel>();
                  final gamePageViewModel = context.read<GamePageViewModel>();
                  final Difficulty difficulty =
                      Difficulty.values.toList().elementAt(index);
                  await startPageViewModel.setDifficulty(difficulty);
                  await gamePageViewModel.updateDifficulty();
                },
                buttonBuilder: (isSelected, text, context) {
                  return Container(
                    width: isSelected ? 40 : 20,
                    height: isSelected ? 40 : 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickPlayButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed("/game"),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
      child: const Text("Quick Play"),
    );
  }
}
