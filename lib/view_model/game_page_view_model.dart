import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/manager/prefs_manager.dart';

import '../model/field.dart';
import '../model/tile.dart';

class GamePageViewModel extends ChangeNotifier {
  late final PrefsManager _prefsManager;

  GamePageViewModel({required PrefsManager prefsManager}) {
    _prefsManager = prefsManager;
  }

  Difficulty _difficulty = Difficulty.normal;

  Difficulty get difficulty => _difficulty;

  Future<void> updateDifficulty() async {
    _difficulty = await _prefsManager.getDifficulty();
    final map = {
      Difficulty.easy: Field(
        row: 10,
        column: 10,
        bombCount: 10,
      ),
      Difficulty.normal: Field(
        row: 18,
        column: 11,
        bombCount: 35,
      ),
      Difficulty.hard: Field(
        row: 20,
        column: 12,
        bombCount: 50,
      ),
    };
    final field = map[_difficulty] ?? Field(row: 1, column: 1, bombCount: 1);
    _tileRowCount = field.row;
    _tileColumnCount = field.column;
    _bombCount = field.bombCount;
    _flagCount = _bombCount;
    _tiles.clear();
    reset();
  }

  int _tileRowCount = 1;
  int _tileColumnCount = 1;
  int _bombCount = 1;
  List<Tile> _tiles = [];

  int get tileRowCount => _tileRowCount;

  int get tileColumnCount => _tileColumnCount;

  int get tileCount => _tileColumnCount * _tileRowCount;

  int get bombCount => _bombCount;

  List<Tile> get tiles => _tiles;

  GameState _state = GameState.beforeGame;

  GameState get state => _state;

  int _flagCount = 1;

  final Stopwatch _stopwatch = Stopwatch();

  Duration _now = const Duration(seconds: 0);

  Duration get now => _now;

  bool _isWatchingTimer = false;

  int get flagCount => _flagCount;

  set state(GameState value) {
    _state = value;
    notifyListeners();
  }

  Future<void> _startWatchingTimer() async {
    while (_isWatchingTimer) {
      await Future.delayed(const Duration(milliseconds: 100));
      _now = _stopwatch.elapsed;
      notifyListeners();
    }
  }

  /// 全タイルを
  /// ・ボムなし
  /// ・閉じている状態
  /// にする
  /// タイマーをリセット
  void reset() {
    _tiles = List.generate(
        _tileColumnCount * _tileRowCount, (index) => Tile(hasBomb: false));
    _state = GameState.beforeGame;
    _isWatchingTimer = false;
    _stopwatch.reset();
    _stopwatch.stop();
    _now = const Duration(seconds: 0);
    _flagCount = _bombCount;
    notifyListeners();
  }

  void openTile(int index) {
    if (_state == GameState.gameOver || _state == GameState.gameClear) {
      return;
    }

    if (_state == GameState.beforeGame) {
      _state = GameState.isPlaying;
      generateRandomList();
      _tiles.shuffle();
      while (existSomethingAt(index)) {
        _tiles.shuffle();
      }
      setBombsAroundCount();
      _stopwatch.start();
      _isWatchingTimer = true;
      _startWatchingTimer();
    }

    if (_tiles[index].hasFlag) {
      return;
    }

    if (_tiles[index].hasBomb) {
      _openSingleTile(index);
      _stopwatch.stop();
      _isWatchingTimer = false;
      HapticFeedback.heavyImpact();
      _state = GameState.gameOver;
    } else {
      _openSafeTilesAround(index);
    }

    if (_tiles.where((tile) => tile.isOpen).length ==
        _tiles.length - _bombCount) {
      _stopwatch.stop();
      _isWatchingTimer = false;
      _state = GameState.gameClear;
    }

    notifyListeners();
  }

  bool existSomethingAt(int index) {
    assert(index > 0 && index < tileCount);
    return _tiles[index].hasBomb || _calculateBombsAroundCount(index) != 0;
  }

  void toggleFlag(int index) {
    if (_tiles[index].isOpen) {
      return;
    }
    _tiles[index].hasFlag = !_tiles[index].hasFlag;
    if (_tiles[index].hasFlag) {
      _flagCount--;
      assert(_flagCount >= -tileCount + _bombCount);
    } else {
      _flagCount++;
      assert(_flagCount <= _bombCount);
    }
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void _openSingleTile(int index) {
    if (_tiles[index].hasFlag) {
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

    if (!_isLeftSide(index)) {
      _openSafeTilesAround(index - 1);
    }
    if (!_isRightSide(index)) {
      _openSafeTilesAround(index + 1);
    }
    if (!_isBottomSide(index)) {
      _openSafeTilesAround(index - _tileColumnCount);
    }
    if (!_isTopSide(index)) {
      _openSafeTilesAround(index + _tileColumnCount);
    }
    if (!(_isLeftSide(index) || _isTopSide(index))) {
      _openSafeTilesAround(index - _tileColumnCount - 1);
    }
    if (!(_isRightSide(index) || _isTopSide(index))) {
      _openSafeTilesAround(index - _tileColumnCount + 1);
    }
    if (!(_isLeftSide(index) || _isBottomSide(index))) {
      _openSafeTilesAround(index + _tileColumnCount - 1);
    }
    if (!(_isRightSide(index) || _isBottomSide(index))) {
      _openSafeTilesAround(index + _tileColumnCount + 1);
    }
  }

  void generateRandomList() {
    int totalTileCount = _tileColumnCount * _tileRowCount;
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

  void setBombsAroundCount() {
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
    } else if (_isTopSide(index)) {
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
    } else if (_isBottomSide(index)) {
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
    } else if (_isLeftSide(index)) {
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
    } else if (_isRightSide(index)) {
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

  /// 左辺のタイルである
  _isLeftSide(int index) => index % _tileColumnCount == 0;

  /// 右辺のタイルである
  _isRightSide(int index) => (index + 1) % _tileColumnCount == 0;

  /// 上辺のタイルである
  _isTopSide(int index) => index > 0 && index < _tileColumnCount - 1;

  /// 下辺のタイルである
  _isBottomSide(int index) =>
      index > _tileColumnCount * (_tileRowCount - 1) &&
      index < _tileColumnCount * _tileRowCount - 1;

  _leftHasBomb(int index) => _tiles[index - 1].hasBomb;

  _topHasBomb(int index) => _tiles[index - _tileColumnCount].hasBomb;

  _rightHasBomb(int index) => _tiles[index + 1].hasBomb;

  _downHasBomb(int index) => _tiles[index + _tileColumnCount].hasBomb;

  _leftTopHasBomb(int index) => _tiles[index - _tileColumnCount - 1].hasBomb;

  _rightTopHasBomb(int index) => _tiles[index - _tileColumnCount + 1].hasBomb;

  _rightDownHasBomb(int index) => _tiles[index + _tileColumnCount + 1].hasBomb;

  _leftDownHasBomb(int index) => _tiles[index + _tileColumnCount - 1].hasBomb;
}
