import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';

class AnimatedTextModel {
  @required final String text;
  @required final Color color;
  @required final int fontSize;

  final int animationLength;
  final int animationDelay;

  AnimatedTextModel({
    this.text,
    this.color,
    this.fontSize,
    this.animationLength: 1000,
    this.animationDelay: 0,
  });
}