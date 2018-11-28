import 'dart:async';

import 'package:buttons/services/context_service.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:buttons/widgets/animated/text/animated_text_model.dart';
import 'package:flutter/widgets.dart';

class BlinkingTextLine extends StatefulWidget {

  final BlinkingTextModel textModel;

  const BlinkingTextLine({Key key, this.textModel}) : super(key: key);

  @override
  State<BlinkingTextLine> createState() => _BlinkingTextLineState();
}

class AnimatedBlinkingText extends AnimatedWidget {

  final ContextService contextService;
  final BlinkingTextModel model;

  AnimatedBlinkingText({Key key, this.model, Animation<double> animation, this.contextService})
    : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: Text(
        model.text,
        style: TextStyle(
          fontFamily: 'LuckiestGuy',
          fontSize: model.fontSize.toDouble(),
          color: model.color
            .withRed((model.color.red * animation.value).floor())
            .withGreen((model.color.green * animation.value).floor())
            .withBlue((model.color.blue * animation.value).floor())
        ),
      ),
    );
  }
}

class _BlinkingTextLineState extends State<BlinkingTextLine> with SingleTickerProviderStateMixin, SubscriberMixin {

  AnimationController controller;
  Animation<double> animation;

  _BlinkingTextLineState();

  initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: widget.textModel.animationLength), vsync: this)
      ..addListener(() {
        this.setState(() {});
      });
    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = Tween(begin: 0.5, end: 1.0).animate(curve);
    Future.delayed(Duration(milliseconds: widget.textModel.animationDelay)).then((_) => _playAnimation());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBlinkingText(
      model: widget.textModel,
      animation: animation,
    );
  }

  dispose() {
    cancelSubscriptions();
    controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    while (true) {
      await controller.forward();
      await controller.reverse();
    }
  }
}

class BlinkingTextModel extends AnimatedTextModel {
  BlinkingTextModel({
    String text,
    Color color,
    int fontSize,
    int animationLength: 1000,
    int animationDelay: 0,
  }) : super(
    color: color,
    text: text,
    fontSize: fontSize,
    animationLength: animationLength,
    animationDelay: animationDelay
  );
}
