import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueGrey,
      child: SafeArea(
        child: ColoredBox(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Minesweeper"),
              const SizedBox(height: 10),
              _quickPlayButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickPlayButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed("/game"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey
      ),
      child: const Text("Quick Play"),
    );
  }
}
