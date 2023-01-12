import 'package:flutter/material.dart';

import 'model/tile.dart';

class GameTile extends StatefulWidget {
  final Tile tile;
  final int neighborBombsCount;

  const GameTile({
    super.key,
    required this.tile,
    this.neighborBombsCount = 0,
  });

  @override
  State<GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  Color _tileColor = Colors.blueGrey;
  int _bombsAroundCount = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.tile.hasBomb) {
          setState(() {
            _tileColor = Colors.red;
          });
        } else {
          setState(() {
            _tileColor = Colors.lightBlueAccent;
            if (widget.neighborBombsCount != 0) {
              _bombsAroundCount = widget.neighborBombsCount;
            }
          });
        }
      },
      child: ColoredBox(
        color: _tileColor,
        child: Center(
          child: _existsBombsAround ? Text("$_bombsAroundCount") : null,
        ),
      ),
    );
  }

  bool get _existsBombsAround => _bombsAroundCount != 0;
}
