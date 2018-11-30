import 'dart:async';
import 'dart:math';

import 'package:buttons/services/context_service.dart';
import 'package:buttons/services/game_service.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:buttons/widgets/animated/text/appearing_text_line.dart';
import 'package:buttons/widgets/animated_widget_proxy.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:spritewidget/spritewidget.dart';
import 'dart:ui' as ui;

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
  NodeWithSize rootNode;
  ParticleSystem particles;
  ImageMap _images;

  final rand = Random();

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

    rootNode = NodeWithSize(Size(400, 600));

    _images = ImageMap(rootBundle);
    _images.load([
      'assets/images/particle-2.png',
    ]).then((_) {
      Timer(Duration(milliseconds: 800), _setUpInitialTimer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        AnimatedCommonEndgameScreen(
          animation: animation,
          contextService: _contextService,
          gameService: _gameService
        ),
        IgnorePointer(child: SpriteWidget(rootNode)),
    ],);
  }

  dispose() {
    cancelSubscriptions();
    controller.dispose();
    super.dispose();
  }

  void _setUpInitialTimer() {
    if (particles != null) {
      rootNode.removeChild(particles);
    }
    if (_gameService.isWon) {
      particles = new ParticleSystem(
        SpriteTexture(_images['assets/images/particle-2.png']),
        life: 0.8,
        lifeVar: 0.2,
        posVar: ui.Offset(0, 0),
        startSize: 0.6,
        startSizeVar: 0.0,
        endSize: 0.0,
        startRotationVar: 90.0,
        direction: 0.0,
        directionVar: 360,
        speed: 400,
        speedVar: 50,
        maxParticles: 200,
        emissionRate: 1700,
        colorSequence: ColorSequence([Color(0x30ffffff)], [0.0]),
        alphaVar: 30,
        redVar: 175,
        greenVar: 175,
        blueVar: 175,
        numParticlesToEmit: 200,
        gravity: ui.Offset(0.0, 250.0),
      );
      particles.position = ui.Offset(
          rand.nextDouble() * 300 + 50,
          rand.nextDouble() * 200 + 50);
      Timer(Duration(milliseconds: ((rand.nextInt(700)+800))), _setUpInitialTimer);

    }
    else {
      particles = new ParticleSystem(
        SpriteTexture(_images['assets/images/particle-2.png']),
        life: 5,
        lifeVar: 0,
        posVar: ui.Offset(400, 0),
        startSize: 0.4,
        endSize: 0.2,
        startRotationVar: 90.0,
        direction: 90.0,
        directionVar: 0,
        speed: 300,
        speedVar: 100,
        maxParticles: 700,
        emissionRate: 700,
        colorSequence: ColorSequence([Color(0x20ffffff)], [0.0]),
        numParticlesToEmit: 700,
        gravity: ui.Offset(0.0, 900.0),
      );
      particles.position = Offset(0, -10);
    }
    rootNode.addChild(particles);
  }
}

