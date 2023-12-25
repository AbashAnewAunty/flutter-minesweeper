import 'package:flutter/material.dart';
import 'package:minesweeper/view_model/game_page_view_model.dart';
import 'package:provider/provider.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final String buttonText;

  const CommonDialog({
    super.key,
    required this.title,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final viewModel = context.read<GamePageViewModel>();
            Navigator.of(context).pop();
            viewModel.reset();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonDialog(title: "Game Over!!", buttonText: "Try Again ?");
  }
}

class GameClearDialog extends StatelessWidget {
  const GameClearDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonDialog(title: "Game Clear!!", buttonText: "Try Again ?");
  }
}
