import 'package:buttons/models/difficulty.dart';

class BoardConfiguration {

  static const boardSizes = [7, 10, 15];

  final int _type;
  final Difficulty _difficulty;

  final List<int> _cellSizes = [48, 36, 24];
  final List<int> _maxTurns = [12, 17, 25];

  final List<List<int>> _difficultyLevels = [
    [10, 11, 12],
    [14, 16, 17],
    [21, 23, 25],
  ];

  BoardConfiguration.small(this._difficulty) : _type = 0;
  BoardConfiguration.medium(this._difficulty) : _type = 1;
  BoardConfiguration.large(this._difficulty) : _type = 2;

  BoardConfiguration(this._type, this._difficulty);

  int get squareSize => boardSizes[_type];
  int get cellDimensionInPixels => _cellSizes[_type];
  int get maxTurns => _maxTurns[_type];
  int get currentDifficultyThreshold => _difficultyLevels.elementAt(_type).elementAt(_difficulty.intValue);
  int get type => _type;

  double get boardDimensionInPixels => (_cellSizes[_type] * boardSizes[_type]).toDouble();
  Difficulty get difficulty => _difficulty;
}