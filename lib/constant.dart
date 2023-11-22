class MyConstants {
  static const int bombCountEasy = 10;
  static const int bombCountNormal = 25;
  static const int bombCountHard = 35;
  static const int rowEasy = 10;
  static const int rowNormal = 14;
  static const int rowHard = 18;
  static const int columnEasy = 10;
  static const int columnNorml = 11;
  static const int columnHard = 12;
}

enum GameState {
  beforeGame,
  isPlaying,
  gameClear,
  gameOver,
}

enum Difficulty {
  easy,
  normal,
  hard,
}
