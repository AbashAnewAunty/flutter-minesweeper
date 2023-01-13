class Tile {
  final bool hasBomb;

  Tile({required this.hasBomb});

  bool isOpen = false;
  int bombsAroundCount = 0;
}
