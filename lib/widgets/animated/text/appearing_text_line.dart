import 'dart:async';

import 'package:buttons/services/context_service.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:buttons/widgets/animated/text/animated_text_model.dart';
import 'package:flutter/widgets.dart';

class AppearingTextLine extends StatefulWidget {

  final AppearingTextModel textModel;

  const AppearingTextLine({Key key, this.textModel}) : super(key: key);

  @override
  State<AppearingTextLine> createState() => _AppearingTextLineState();
}

class AnimatedAppearingText extends AnimatedWidget {

  final ContextService contextService;
  final AppearingTextModel model;

  AnimatedAppearingText({Key key, this.model, Animation<double> animation, this.contextService})
    : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: GestureDetector(
        child: Text(
          model.text,
          style: TextStyle(
            fontFamily: 'LuckiestGuy',
            fontSize: model.fontSize.toDouble() * animation.value,
            color: model.color,
          ),
        ),
        onTapDown: (_) {
          model.onTap();
        }
      ),
    );
  }
}

class _AppearingTextLineState extends State<AppearingTextLine> with SingleTickerProviderStateMixin, SubscriberMixin {

  AnimationController controller;
  Animation<double> animation;
  ContextService _contextService;

  _AppearingTextLineState();

  initState() {
    super.initState();

    _contextService = getInjected<ContextService>();

    controller = AnimationController(
      duration: Duration(milliseconds: widget.textModel.animationLength), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    Future.delayed(Duration(milliseconds: widget.textModel.animationDelay)).then((_) => controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAppearingText(
      model: widget.textModel,
      animation: animation,
      contextService: _contextService
    );
  }

  dispose() {
    cancelSubscriptions();
    controller.dispose();
    super.dispose();
  }
}

class AppearingTextModel extends AnimatedTextModel {
  final Function onTap;

  AppearingTextModel({
    String text,
    Color color,
    int fontSize,
    int animationLength: 1000,
    int animationDelay: 0,
    this.onTap,
  }) : super(
    color: color,
    text: text,
    fontSize: fontSize,
    animationLength: animationLength,
    animationDelay: animationDelay
  );
}
