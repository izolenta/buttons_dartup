import 'dart:async';

import 'package:buttons/services/game_service.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:flutter/widgets.dart';


class TimeCounter extends StatefulWidget {
  @override
  State<TimeCounter> createState() => _TimeCounterState();

}

class _TimeCounterState extends State<TimeCounter> with DimensionHelper {

  Timer t;
  GameService _service;

  _TimeCounterState();

  @override
  void initState() {
    super.initState();
    _service = getInjected<GameService>();
    t = Timer.periodic(Duration(seconds: 1), (_) => this.setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: getWidth(context) * 0.65,
      top: getHeight(context) * 0.03,
      child: Container(
        width: getWidth(context) * 0.30,
        alignment: Alignment.topLeft,
        child: Text(
          'Time ${_service.playingTimeString}',
          style: TextStyle(
            fontFamily: 'LuckiestGuy',
            fontSize: 22.0 * getFactor(context),
            color: Color(0xff83ce0b),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }
}