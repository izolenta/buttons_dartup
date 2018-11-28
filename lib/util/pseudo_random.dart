import 'dart:core';

class PseudoRandom
{
  static const MASK32 = (1<<32) - 1;
  int _next;

  PseudoRandom() {
    _next = new DateTime.now().millisecondsSinceEpoch;
  }

  static int get randomSeed => new DateTime.now().millisecondsSinceEpoch & MASK32;

  PseudoRandom.fromSeed(num seed){
    _next = seed;
  }

  int nextInt(int max)
  {
    _next = (64525 * _next + 1013904223) & MASK32;
    var stripped = (_next + 1.0)*2.328306435454494e-10;
    return (stripped*max).floor();
  }
}