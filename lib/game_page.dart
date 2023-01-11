import 'package:flutter/material.dart';

import 'model/tile.dart';

class GamePage extends StatelessWidget {
  static const _tileRowCount = 18;
  static const _tileColumnCount = 11;
  static const _bombCount = 35;
  late final List<Tile> _tiles;

  GamePage({super.key}) {
    _tiles = _generateRandomList(_tileRowCount * _tileColumnCount, _bombCount);
  }

  List<Tile> _generateRandomList(int totalCount, int bombCount) {
    final tiles = List.generate(
      totalCount,
      (index) {
        if (index < _bombCount) {
          return Tile(hasBomb: true);
        } else {
          return Tile(hasBomb: false);
        }
      },
    );
    tiles.shuffle();
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueGrey,
      child: SafeArea(
        child: Container(
          color: Colors.blueGrey,
          child: Column(
            children: [
              _tempAppbar(),
              Expanded(
                child: Center(
                  child: GridView.count(
                    crossAxisCount: _tileColumnCount,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    children: List.generate(
                      _tiles.length,
                      (index) => ColoredBox(
                        color: _tiles[index].hasBomb ? Colors.red : Colors.grey,
                      ),
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
