import 'package:buttons/models/board_configuration.dart';
import 'package:buttons/services/game_service.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:buttons/widgets/tap_to_start_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Board extends StatefulWidget{

  @override
  _BoardState createState() => _BoardState();

}

class _BoardState extends State<Board> with SubscriberMixin, DimensionHelper {

  final GameService _service = getInjected<GameService>();
  final scaleMatrix = Matrix4.rotationZ(0.2);

  BoardConfiguration get boardSize => _service.boardConfig;

  _BoardState() {
    scaleMatrix.scale(0.9);
    subscriptions.add(_service.onStateChanged.listen((_) {
      if (_service.isInProgress) {
        setState(() => {});
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    final gap = getWidth(context) * 0.028;
    var allRows = <Widget>[
      Positioned(
        child: new Image.asset('assets/images/frame1515.png'),
        height: boardSize.boardDimensionInPixels * getFactor(context) + gap * 2,
        width: boardSize.boardDimensionInPixels * getFactor(context)+ gap * 2,
      )
    ];

    for (int i=0; i<boardSize.squareSize; i++) {
      var nextRow = <Widget>[];
      for (int j=0; j<boardSize.squareSize; j++) {
        nextRow.add(Positioned(
          child: _createButtonImage(i, j),
          left: j*boardSize.cellDimensionInPixels.toDouble() * getFactor(context) + gap,
          top: i*boardSize.cellDimensionInPixels.toDouble() * getFactor(context) + gap,
        ));
      }
      allRows.add(Stack(
        children: nextRow,
      ));
    }
    if (_service.isWaitingForStart) {
      final tapToStart = TapToStartButton();
      allRows.add(tapToStart);
    }

    var stack = new Stack(
      children: allRows,
    );

    return new Container(
      width: boardSize.boardDimensionInPixels * getFactor(context) + gap * 2,
      height: boardSize.boardDimensionInPixels * getFactor(context) + gap * 2,
      child: stack,
    );
  }

  Widget _createButtonImage(int i, int j) {
    final cell = _service.boardCells[i*_service.boardConfig.squareSize + j];
    final asset = Image.asset(
      _service.isInProgress
        ? cell.isFixed
          ? 'assets/images/button-mark-${cell.color+1}.png'
          : 'assets/images/button${cell.color+1}.png'
        : 'assets/images/button-gray.png',
      height: boardSize.cellDimensionInPixels.toDouble() * getFactor(context),
      width: boardSize.cellDimensionInPixels.toDouble() * getFactor(context),
      color: _service.isInProgress && cell.isFixed? Color(0x00000000): Color(0x77000000),
      colorBlendMode: BlendMode.darken,
    );
    if (!cell.isFixed || _service.isWaitingForStart) {
      final transform = Transform(
        transform: scaleMatrix,
        alignment: FractionalOffset.center,
        child: asset,
      );
      return transform;
    }
    return asset;
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
}