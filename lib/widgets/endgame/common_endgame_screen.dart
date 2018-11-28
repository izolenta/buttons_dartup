import 'dart:async';

import 'package:buttons/services/context_service.dart';
import 'package:buttons/services/game_service.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:buttons/widgets/animated/text/appearing_text_line.dart';
import 'package:buttons/widgets/animated_widget_proxy.dart';
import 'package:flutter/widgets.dart';

class CommonEndgameScreen extends StatefulWidget {

  @override
  State<CommonEndgameScreen> createState() => _CommonEndgameScreenState();
}

class AnimatedCommonEndgameScreen extends AnimatedWidgetProxy with DimensionHelper {

  final ContextService contextService;
  final GameService gameService;

  AnimatedCommonEndgameScreen({
    Animation<double> animation,
    this.contextService,
    this.gameService
  })
    : super(animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    final widgets = <Widget>[];

    if (gameService.isLost) {
      widgets.add(Positioned(
        width: getWidth(context),
        top: getHeight(context) * 0.17,
        child: AppearingTextLine(
          textModel: AppearingTextModel(
            color: Color(0xffc5060b),
            fontSize: (48 * getFactor(context)).floor(),
            animationDelay: 400,
            animationLength: 800,
            text: 'You lost :('
          )
        )
      ));

      widgets.add(Positioned(
        width: getWidth(context),
        top: getHeight(context) * 0.27,
        child: AppearingTextLine(
          textModel: AppearingTextModel(
            color: Color(0xffd61db0),
            fontSize: (28 * getFactor(context)).floor(),
            animationDelay: 700,
            animationLength: 800,
            text: 'No turns left'
          )
        )
      ));
    }
    else if (gameService.isWon) {
      widgets.add(Positioned(
        width: getWidth(context),
        top: getHeight(context) * 0.17,
        child: AppearingTextLine(
          textModel: AppearingTextModel(
            color: Color(0xffc5060b),
            fontSize: (48 * getFactor(context)).floor(),
            animationDelay: 400,
            animationLength: 800,
            text: 'Awesome!'
          )
        )
      ));

      widgets.add(Positioned(
        width: getWidth(context),
        top: getHeight(context) * 0.27,
        child: AppearingTextLine(
          textModel: AppearingTextModel(
            color: Color(0xffd61db0),
            fontSize: (28 * getFactor(context)).floor(),
            animationDelay: 700,
            animationLength: 800,
            text: '${gameService.boardConfig.maxTurns - gameService.turns} turns used'
          )
        )
      ));
    }

    widgets.add(Positioned(
      width: getWidth(context),
      top: getHeight(context) * 0.43,
      child: AppearingTextLine(
        textModel: AppearingTextModel(
          color: Color(0xff1ea0cb),
          fontSize: (34 * getFactor(context)).floor(),
          animationDelay: 1000,
          animationLength: 800,
          text: 'Start A New Game',
          onTap: () => gameService.initNewGame()
        )
      )
    ));

    return Container(
      width: getWidth(context),
      height: getHeight(context),
      alignment: Alignment.topCenter,
      child: Stack(
        children:
          widgets,
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB((240*animation.value).floor(), 0, 0, 0),
      ),
    );
  }
}

class _CommonEndgameScreenState extends State<CommonEndgameScreen> with SingleTickerProviderStateMixin, SubscriberMixin {

  AnimationController controller;
  Animation<double> animation;
  ContextService _contextService;
  GameService _gameService;

  initState() {
    super.initState();

    _gameService = getInjected<GameService>();
    _contextService = getInjected<ContextService>();

    controller = AnimationController(
      duration: const Duration(milliseconds: 300), vsync: this)
      ..addListener(() {
        this.setState(() {});
      });
    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    Future.delayed(Duration(milliseconds: 100)).then((_) => controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCommonEndgameScreen(
      animation: animation,
      contextService: _contextService,
      gameService: _gameService
    );
  }

  dispose() {
    cancelSubscriptions();
    controller.dispose();
    super.dispose();
  }
}

