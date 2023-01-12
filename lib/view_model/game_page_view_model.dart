import 'package:flutter/cupertino.dart';

import '../model/tile.dart';

class GamePageViewModel extends ChangeNotifier{
  static const int _tileRowCount = 18;
  static const int _tileColumnCount = 11;
  static const int _bombCount = 35;
  List<Tile> _tiles = [];

  int get tileRowCount => _tileRowCount;

  int get tileColumnCount => _tileColumnCount;

  int get bombCount => _bombCount;

  List<Tile> get tiles => _tiles;

  void generateRandomList() {
    const int totalTileCount = _tileColumnCount * _tileRowCount;
    _tiles.clear();
    _tiles = List.generate(
      totalTileCount,
          (index) {
        if (index < _bombCount) {
          return Tile(hasBomb: true);
        } else {
          return Tile(hasBomb: false);
        }
      },
    );
    _tiles.shuffle();
  }

  /// TODO: リファクタリング
  int calculateBombsAroundCount(int tileIndex) {
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