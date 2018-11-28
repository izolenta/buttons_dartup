import 'dart:async';

import 'package:buttons/services/scenes/scene_manager.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/widgets/menus/game_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuScene extends StatefulWidget {

  @override
  State<MenuScene> createState() => _MenuSceneState();
}

class _MenuSceneState extends State<MenuScene> with DimensionHelper {

  var opacity = 0.0;
  final SceneManager _manager = getInjected<SceneManager>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((_) => setState(() => opacity = 1.0));
  }

  @override
  Widget build(BuildContext context) {

    final children = _fillChildren();

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
      Stack(
        children: children
      ),
    ];
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
    super.dispose();
  }

  List<Widget> _fillChildren() {
    final list = <Widget>[];
    list.add(Positioned(child: Image.asset('assets/images/wrike-logo-small.png', scale: 4.0 / getFactor(context), color: Color(0x55000000), colorBlendMode: BlendMode.multiply,), top: getHeight(context) * 0.12, left: getWidth(context) * 0.16));
    list.add(Positioned(child: Image.asset('assets/images/logo-skewed.png', scale: 2.7 / getFactor(context), ), top: getHeight(context) * 0.14, width: getWidth(context)));
    list.add(Positioned(child: GameMenu(onPressStart: () async {
        setState(() => opacity = 0.0);
        await Future.delayed(Duration(milliseconds: 500));
        _manager.switchToGameScene();
      }
    ), top: getHeight(context)*3/7, width: getWidth(context)));
    return list;
  }
}