import 'package:flutter/material.dart';
import 'package:minesweeper/game_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Minesweeper"),
            const SizedBox(height: 10),
            _quickPlayButton(context),
          ],
        ),
      ),
    );
  }

  Widget _quickPlayButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed("/game"),
      child: const Text("Quick Play"),
    );
  }
}
