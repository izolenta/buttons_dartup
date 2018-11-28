import 'dart:async';

import 'package:buttons/services/context_service.dart';
import 'package:buttons/services/game_service.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:buttons/widgets/animated_widget_proxy.dart';
import 'package:flutter/widgets.dart';

class TapToStartButton extends StatefulWidget {
  @override
  State<TapToStartButton> createState() => _TapToStartButtonState();
}

class AnimatedTapToStart extends AnimatedWidgetProxy with DimensionHelper {

  final ContextService contextService = getInjected<ContextService>();
  final GameService gameService = getInjected<GameService>();

  AnimatedTapToStart({Key key, Animation<double> animation})
    : super(animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: GestureDetector(
        child: Container(
          width: getWidth(context) * animation.value,
          height: getHeight(context) * 0.19  * animation.value,
          child: SingleChildScrollView( //fuck you, rendering overflow
            padding: EdgeInsets.only(top: getHeight(context) * 0.042 * animation.value),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Tap to start!',
                    style: TextStyle(
                      fontFamily: 'LuckiestGuy',
                      fontSize: 40.0 * getFactor(context) * animation.value,
                      color: Color(0xffffe131),
                    ),
                  ),
                  Text(
                    '${gameService.boardConfig.maxTurns} turns to go',
                    style: TextStyle(
                      fontFamily: 'LuckiestGuy',
                      fontSize: 28.0 * getFactor(context) * animation.value,
                      color: Color(0xffffe131),
                    ),
                  ),
                ]
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Color(0xcc000000),
            border: Border(
              top: BorderSide(color: Color(0xbbffffff), width: 2.0 * getFactor(context)),
              bottom: BorderSide(color: Color(0xbbffffff), width: 2.0 * getFactor(context))
            ),
          ),
        ),
        onTapDown: (_) {
          contextService.firePressTapToStart();
        },
      ),
    );
  }
}

class _TapToStartButtonState extends State<TapToStartButton> with SingleTickerProviderStateMixin, SubscriberMixin {

  AnimationController controller;
  Animation<double> animation;
  final GameService _gameService = getInjected<GameService>();
  final ContextService _contextService = getInjected<ContextService>();

  initState() {
    subscriptions.add(_contextService.onTapToStart.listen((_) {
      backward();
    }));

    controller = AnimationController(
      duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() {
        this.setState(() {});
      });
    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    Future.delayed(Duration(milliseconds: 200)).then((_) => controller.forward());
    super.initState();

  }

  void backward() {
    controller.duration = Duration(milliseconds: 500);
    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation = ReverseTween(Tween(begin: 0.0, end: 1.0)).animate(curve);
    controller.reset();
    controller.forward();
    Future.delayed(Duration(milliseconds: 600)).then((_) {
      _gameService.startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTapToStart(animation: animation);
  }

  dispose() {
    cancelSubscriptions();
    controller.dispose();
    super.dispose();
  }
}

