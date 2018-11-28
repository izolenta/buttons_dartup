import 'dart:async';

import 'package:buttons/services/game_service.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:buttons/widgets/board.dart';
import 'package:buttons/widgets/endgame/common_endgame_screen.dart';
import 'package:buttons/widgets/switch_color_panel.dart';
import 'package:buttons/widgets/top_menu/top_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameScene extends StatefulWidget {

  @override
  State<GameScene> createState() => _GameSceneState();
}

class _GameSceneState extends State<GameScene> with SubscriberMixin, DimensionHelper {

  final GameService _gameService = getInjected<GameService>();

  var opacity = 0.0;

  @override
  initState() {
    subscriptions.add(_gameService.onStateChanged.listen((_) => setState(() {})));
    Future.delayed(Duration(milliseconds: 50)).then((_) => setState(() => opacity = 1.0));
    _gameService.initNewGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> children = _gameService.isInitializingGame
        ? []
        : [
            TopMenuBar(),
            Board(),
            SwitchColorPanel(),
          ];

    List<Widget> widgets = [
      Container(
        width: getWidth(context),
        height: getHeight(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/bg3.jpg',
            ),
            colorFilter: ColorFilter.mode(Color(0x55000000), BlendMode.darken),
          ),
        ),
      ),
      Column(
        children: children
      ),
    ];

    if (_gameService.isEnded) {
      widgets.add(CommonEndgameScreen());
    }

    return Scaffold(
      backgroundColor: Color(0xff000000),
      body: AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 500),
        child: Stack(
          children: widgets,
        ),
      ),
    );
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
}