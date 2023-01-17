import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:minesweeper/constant.dart';

import '../model/tile.dart';

class GamePageViewModel extends ChangeNotifier {
  static const int _tileRowCount = 18;
  static const int _tileColumnCount = 11;
  static const int _bombCount = 35;
  List<Tile> _tiles = List.generate(_tileColumnCount * _tileRowCount, (index) => Tile(hasBomb: false));

  int get tileRowCount => _tileRowCount;

  int get tileColumnCount => _tileColumnCount;

  int get tileCount => _tileColumnCount * _tileRowCount;

  int get bombCount => _bombCount;

  List<Tile> get tiles => _tiles;

  GameState _state = GameState.beforeGame;

  GameState get state => _state;

  set state(GameState value) {
    _state = value;
    notifyListeners();
  }

  void reset(){
    _tiles = List.generate(_tileColumnCount * _tileRowCount, (index) => Tile(hasBomb: false));
    _state = GameState.beforeGame;
    notifyListeners();
  }

  void openTile(int index) {

    if(_state == GameState.gameOver || _state == GameState.gameClear){
      return;
    }

    if(_state == GameState.beforeGame){
      _state = GameState.isPlaying;
      generateRandomList();
      _tiles.shuffle();
      while(existSomethingAt(index)){
        _tiles.shuffle();
      }
      setBombsAroundCount();
    }

    if (_tiles[index].hasBomb) {
      _openSingleTile(index);
      HapticFeedback.heavyImpact();
      _state = GameState.gameOver;
    } else {
      _openSafeTilesAround(index);
    }
    notifyListeners();
  }

  bool existSomethingAt(int index){
    assert(index > 0 && index < tileCount);
    return _tiles[index].hasBomb || _calculateBombsAroundCount(index) != 0;
  }

  void toggleFlag(int index) {
    if (_tiles[index].isOpen) {
      return;
    }
    _tiles[index].hasFlag = !_tiles[index].hasFlag;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void _openSingleTile(int index) {
    if(_tiles[index].hasFlag){
      return;
    }
    _tiles[index].isOpen = true;
  }

  void _openSafeTilesAround(int index) {
    if (index.isNegative || index >= _tiles.length) {
      return;
    }
    if (_tiles[index].hasBomb) {
      return;
    }
    if (_tiles[index].isOpen) {
      return;
    }
    if (_tiles[index].hasFlag) {
      return;
    }

    _openSingleTile(index);

    if (_tiles[index].bombsAroundCount != 0) {
      return;
    }

    _openSafeTilesAround(index - 1);
    _openSafeTilesAround(index + 1);
    _openSafeTilesAround(index - _tileColumnCount);
    _openSafeTilesAround(index + _tileColumnCount);
    _openSafeTilesAround(index - _tileColumnCount - 1);
    _openSafeTilesAround(index - _tileColumnCount + 1);
    _openSafeTilesAround(index + _tileColumnCount - 1);
    _openSafeTilesAround(index + _tileColumnCount + 1);
  }

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
  }

  void setBombsAroundCount(){
    for (int i = 0; i < _tiles.length; i++) {
      final int bombsAroundCount = _calculateBombsAroundCount(i);
      _tiles[i].bombsAroundCount = bombsAroundCount;
    }
  }

  int _calculateBombsAroundCount(int index) {
    int resultBombCount = 0;
    if (index == 0) {
      /// 左上
      if (_rightHasBomb(index)) {
        resultBombCount++;
      }
      if (_downHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightHasBomb(index)) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (index == _tileColumnCount - 1) {
      /// 右上
      if (_leftHasBomb(index)) {
        resultBombCount++;
      }
      if (_downHasBomb(index)) {
        resultBombCount++;
      }
      if (_leftDownHasBomb(index)) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (index == _tileColumnCount * (_tileRowCount - 1)) {
      /// 左下
      if (_rightHasBomb(index)) {
        resultBombCount++;
      }
      if (_topHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightTopHasBomb(index)) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (index == _tileColumnCount * _tileRowCount - 1) {
      /// 右下
      if (_leftHasBomb(index)) {
        resultBombCount++;
      }
      if (_topHasBomb(index)) {
        resultBombCount++;
      }
      if (_leftTopHasBomb(index)) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (index > 0 && index < _tileColumnCount - 1) {
      /// 上辺
      if (_leftHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightHasBomb(index)) {
        resultBombCount++;
      }
      if (_leftDownHasBomb(index)) {
        resultBombCount++;
      }
      if (_downHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightDownHasBomb(index)) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (index > _tileColumnCount * (_tileRowCount - 1) &&
        index < _tileColumnCount * _tileRowCount - 1) {
      /// 下辺
      if (_leftHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightHasBomb(index)) {
        resultBombCount++;
      }
      if (_leftTopHasBomb(index)) {
        resultBombCount++;
      }
      if (_topHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightTopHasBomb(index)) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if (index % _tileColumnCount == 0) {
      /// 左辺
      if (_rightHasBomb(index)) {
        resultBombCount++;
      }
      if (_topHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightTopHasBomb(index)) {
        resultBombCount++;
      }
      if (_downHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightDownHasBomb(index)) {
        resultBombCount++;
      }
      return resultBombCount;
    } else if ((index + 1) % _tileColumnCount == 0) {
      /// 右辺
      if (_leftHasBomb(index)) {
        resultBombCount++;
      }
      if (_topHasBomb(index)) {
        resultBombCount++;
      }
      if (_leftTopHasBomb(index)) {
        resultBombCount++;
      }
      if (_downHasBomb(index)) {
        resultBombCount++;
      }
      if (_leftDownHasBomb(index)) {
        resultBombCount++;
      }
      return resultBombCount;
    } else {
      /// その他
      if (_rightHasBomb(index)) {
        resultBombCount++;
      }
      if (_leftHasBomb(index)) {
        resultBombCount++;
      }
      if (_topHasBomb(index)) {
        resultBombCount++;
      }
      if (_leftTopHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightTopHasBomb(index)) {
        resultBombCount++;
      }
      if (_downHasBomb(index)) {
        resultBombCount++;
      }
      if (_leftDownHasBomb(index)) {
        resultBombCount++;
      }
      if (_rightDownHasBomb(index)) {
        resultBombCount++;
      }
      return resultBombCount;
    }
  }

  _leftHasBomb(int index) => _tiles[index - 1].hasBomb;

  _topHasBomb(int index) => _tiles[index - _tileColumnCount].hasBomb;

  _rightHasBomb(int index) => _tiles[index + 1].hasBomb;

  _downHasBomb(int index) => _tiles[index + _tileColumnCount].hasBomb;

  _leftTopHasBomb(int index) => _tiles[index - _tileColumnCount - 1].hasBomb;

  _rightTopHasBomb(int index) => _tiles[index - _tileColumnCount + 1].hasBomb;

  _rightDownHasBomb(int index) => _tiles[index + _tileColumnCount + 1].hasBomb;

  _leftDownHasBomb(int index) => _tiles[index + _tileColumnCount - 1].hasBomb;
}
