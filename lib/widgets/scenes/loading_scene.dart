import 'dart:async';

import 'package:buttons/services/scenes/scene_manager.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/precacher.dart';
import 'package:buttons/widgets/animated/text/blinking_text_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:buttons/services/database_service.dart';

class LoadingScene extends StatefulWidget {

  @override
  State<LoadingScene> createState() => _LoadingSceneState();
}

class _LoadingSceneState extends State<LoadingScene> with DimensionHelper {

  final DatabaseService _dbService = getInjected<DatabaseService>();
  final SceneManager _manager = getInjected<SceneManager>();
  final Precacher _precacher = getInjected<Precacher>();

  var opacity = 1.0;

  @override
  void initState() {
    _precacher.onPrecachingDone.listen((_) => setState(() {}));
    _doInitialLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = _precacher.areAssetsPrecached? [
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
      Center(
        child: BlinkingTextLine(
          textModel: BlinkingTextModel(text: 'Loading...', animationLength: 1500, fontSize: (36 * getFactor(context)).floor(), color: Color(0xff73c506)),
        ),
      ),
    ] : [];
    return Scaffold(
      backgroundColor: Color(0xFF000000),
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

  Future<void> _doInitialLoading() async {
    await Future.wait([
      _dbService.initService(),
      Future.delayed(Duration(seconds: 5)),
    ]);
    setState(() {
      opacity = 0.0;
    });
    await Future.delayed(Duration(milliseconds: 500));
    _manager.switchToMenuScene();
  }
}