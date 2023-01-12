import 'package:flutter/material.dart';

import 'game_tile.dart';
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
          color: Colors.grey,
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
                      (index) {
                        _calculateBombsAroundCount(index);
                        return GameTile(
                          tile: _tiles[index],
                          getBombsAroundCount: () {
                            return _calculateBombsAroundCount(index);
                          },
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

  /// TODO: リファクタリング
  int _calculateBombsAroundCount(int tileIndex) {
    int resultBombCount = 0;
    if (tileIndex == 0) {
      /// 左上
      if (_tiles[tileIndex + 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount + 1].hasBomb) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (tileIndex == _tileColumnCount - 1) {
      /// 右上
      if (_tiles[tileIndex - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount - 1].hasBomb) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (tileIndex == _tileColumnCount * (_tileRowCount - 1)) {
      /// 左下
      if (_tiles[tileIndex + 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount + 1].hasBomb) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (tileIndex == _tileColumnCount * _tileRowCount - 1) {
      /// 右下
      if (_tiles[tileIndex - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount - 1].hasBomb) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (tileIndex > 0 && tileIndex < _tileColumnCount - 1) {
      /// 上辺
      if (_tiles[tileIndex - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount + 1].hasBomb) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (tileIndex > _tileColumnCount * (_tileRowCount - 1) &&
        tileIndex < _tileColumnCount * _tileRowCount - 1) {
      /// 下辺
      if (_tiles[tileIndex - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount + 1].hasBomb) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (tileIndex % _tileColumnCount == 0) {
      /// 左辺
      if (_tiles[tileIndex + 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount + 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount + 1].hasBomb) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if ((tileIndex + 1) % _tileColumnCount == 0) {
      /// 右辺
      if (_tiles[tileIndex - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount - 1].hasBomb) {
        resultBombCount++;
      }
      return resultBombCount;
    } else {
      /// その他
      if (_tiles[tileIndex + 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex - _tileColumnCount + 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount - 1].hasBomb) {
        resultBombCount++;
      }
      if (_tiles[tileIndex + _tileColumnCount + 1].hasBomb) {
        resultBombCount++;
      }
      return resultBombCount;
    }
  }
}
