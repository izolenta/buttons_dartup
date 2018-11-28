//a dirty hack because of https://github.com/dart-lang/sdk/issues/31543
import 'package:flutter/widgets.dart';

class AnimatedWidgetProxy extends AnimatedWidget {
  AnimatedWidgetProxy(Listenable listenable) : super(listenable: listenable);
  @override
  Widget build(BuildContext context) => null;
}