import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          color: Colors.blueGrey,
          child: const Center(
            child: Text("developing"),
          ),
        ),
      ),
    );
  }
}
