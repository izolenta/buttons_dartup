import 'dart:async';

import 'package:buttons/models/board_configuration.dart';
import 'package:buttons/models/cell_state.dart';
import 'package:buttons/models/difficulty.dart';
import 'package:buttons/services/database_service.dart';
import 'package:buttons/services/game_state.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/pseudo_random.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameService {

  final DatabaseService _dbService = getInjected<DatabaseService>();

  BoardConfiguration _boardConfig;
  BoardConfiguration get boardConfig => _boardConfig;

  List<CellState> boardCells = [];
  Stopwatch _playingTime;
  int _turns = 0;
  GameState _gameState;
  SharedPreferences localPrefs;

  // ignore: close_sinks
  StreamController<void> _onStateChangedController = new StreamController<void>.broadcast();
  Stream get onStateChanged => _onStateChangedController.stream;

  int get turns => _turns;

  bool get isWaitingForStart => _gameState == GameState.waitingForStart;
  bool get isInitializingGame => _gameState == GameState.initializingGame;
  bool get isInProgress => _gameState == GameState.gameInProgress;
  bool get isPaused => _gameState == GameState.gamePaused;
  bool get isWon => _gameState == GameState.gameWon;
  bool get isLost => _gameState == GameState.gameLost;
  bool get isTied => _gameState == GameState.gameTied;
  bool get isEnded => isWon || isLost || isTied;

  int get currentActiveColor => boardCells.isNotEmpty? boardCells[0].color : 0;

  String get playingTimeString {
    final seconds = _playingTime.elapsed.inSeconds % 60;
    var minutes = _playingTime.elapsed.inMinutes;
    if (minutes > 99) {
      return '99:59';
    }
    var result = minutes < 10? '0$minutes:' : '$minutes:';
    result += seconds < 10? '0$seconds' : '$seconds';
    return result;
  }

  GameService(int boardType, int diffType) {
    _boardConfig = BoardConfiguration(boardType, Difficulty(diffType));
  }

  Future<void> initNewGame() async {
    _gameState = GameState.initializingGame;
    _onStateChangedController.add(null);
    _playingTime = new Stopwatch();
    _turns = boardConfig.maxTurns;
    int seed = await _dbService.getNewSeedForGame(_boardConfig.squareSize, _boardConfig.difficulty);
    final rand = new PseudoRandom.fromSeed(seed);
    boardCells.clear();
    for (int i=0; i < _boardConfig.squareSize; i++) {
      for (int j=0; j < _boardConfig.squareSize; j++) {
        boardCells.add(new CellState(
          rand.nextInt(6), false, j, i,
        ));
      }
    }
    boardCells[0] = boardCells[0].rebuildWith(isFixed: true);
    makeTurn(boardCells[0].color, initial: true);
    _gameState = GameState.waitingForStart;
    _onStateChangedController.add(null);
  }

  void _updateCell(int x, int y, {int color, bool fixed}) {
    if (x >=0 && y>=0 && x < _boardConfig.squareSize && y < boardConfig.squareSize) {
      final index = y * _boardConfig.squareSize + x;
      boardCells[index] = boardCells[index].rebuildWith(
          x: x, y: y, color: color, isFixed: fixed);
    }
  }

  void makeTurn(int color, {bool initial: false}) {
    for (var next in boardCells.where((cell) => cell.isFixed)) {
      _updateCell(next.x, next.y, color: color);
      _doRecursivePaint(next, color);
    }
    if (!initial) {
      _turns--;
      if (boardCells.every((t) => t.color == boardCells[0].color)) {
        stopPlayingTime();
        _gameState = GameState.gameWon;
      }
      else if (turns == 0) {
        stopPlayingTime();
        _gameState = GameState.gameLost;
      }
    }
    _onStateChangedController.add(null);
  }

  void _doRecursivePaint(CellState next, int color) {
    for (int i=-1; i<2; i+=2) {
      int newY = next.y + i;
      if (newY >= 0 && newY < _boardConfig.squareSize) {
        int index = newY * _boardConfig.squareSize + next.x;
        if (!boardCells[index].isFixed && boardCells[index].color == color) {
          _updateCell(index % _boardConfig.squareSize, index ~/ _boardConfig.squareSize, color: color, fixed: true);
          _doRecursivePaint(boardCells[index], color);
        }
      }
    }
    for (int i=-1; i<2; i+=2) {
      int newX = next.x + i;
      if (newX >= 0 && newX < _boardConfig.squareSize) {
        int index = next.y * _boardConfig.squareSize + newX;
        if (!boardCells[index].isFixed && boardCells[index].color == color) {
          _updateCell(index % _boardConfig.squareSize, index ~/ _boardConfig.squareSize, color: color, fixed: true);
          _doRecursivePaint(boardCells[index], color);
        }
      }
    }
  }

  void startGame() {
    _gameState = GameState.gameInProgress;
    _playingTime.start();
    _onStateChangedController.add(null);
  }

  void stopPlayingTime() {
    _playingTime.stop();
  }

  void changeSize(int type) {
    _boardConfig = BoardConfiguration(type, _boardConfig.difficulty);
    getSharedPreferences().then((_) => _.setInt('boardType', type));
  }

  void changeDifficulty(int type) {
    _boardConfig = BoardConfiguration(_boardConfig.type, Difficulty(type));
    getSharedPreferences().then((_) => _.setInt('diffType', type));
  }

  Future<SharedPreferences> getSharedPreferences() async {
    if (localPrefs == null) {
      localPrefs = await SharedPreferences.getInstance();
    }
    return localPrefs;
  }
}