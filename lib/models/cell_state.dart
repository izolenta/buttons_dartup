class CellState {
  final int color;
  final bool isFixed;
  final int x;
  final int y;
  CellState(this.color, this.isFixed, this.x, this.y);

  CellState rebuildWith({int color, bool isFixed, int x, int y}) {
    return CellState(
      color?? this.color,
      isFixed?? this.isFixed,
      x?? this.x,
      y?? this.y,
    );
  }
}