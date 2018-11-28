import 'dart:async';

import 'package:buttons/util/subscriber.dart';
import 'package:flutter/widgets.dart';

class MenuButton extends StatefulWidget {

  final Function onPress;
  final Widget child;
  const MenuButton({Key key, this.child, this.onPress}) : super(key: key);

  @override
  State<MenuButton> createState() => _MenuButtonState();

}

class AnimatedMenuButton extends AnimatedWidget {


  final Widget child;

  AnimatedMenuButton({Key key, this.child, Animation<double> animation})
    : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Transform.scale(
      child: child,
      scale: animation.value);
  }
}

class _MenuButtonState extends State<MenuButton> with SingleTickerProviderStateMixin, SubscriberMixin {

  AnimationController controller;
  Animation<double> animation;

  _MenuButtonState();

  initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 200), vsync: this)
      ..addListener(() {
        this.setState(() {});
      });
    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = TweenSequence([
      TweenSequenceItem(tween: ReverseTween(Tween(begin: 0.9, end: 1.0)), weight: 0.1),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 0.9),
    ]).animate(curve);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Transform.scale(
          child: AnimatedMenuButton(
            child: widget.child,
            animation: animation,
          ),
          scale: animation.value),
        onTapDown: (_) {
          _startAnimation();
          Timer(Duration(milliseconds: 200), widget.onPress);
        }
      ),
    );
  }

  void _startAnimation() {
    controller.reset();
    controller.forward();
  }

  dispose() {
    cancelSubscriptions();
    controller.dispose();
    super.dispose();
  }
}