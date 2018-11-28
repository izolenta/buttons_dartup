import 'dart:async';

import 'package:flutter/widgets.dart';

class Precacher {

  bool areAssetsPrecached = false;

  // ignore: close_sinks
  StreamController<void> _onPrecachingDone = new StreamController<void>.broadcast();
  Stream get onPrecachingDone => _onPrecachingDone.stream;

  static const assetImages = [
    'assets/images/button1.png',
    'assets/images/button2.png',
    'assets/images/button3.png',
    'assets/images/button4.png',
    'assets/images/button5.png',
    'assets/images/button6.png',
    'assets/images/button-mark-1.png',
    'assets/images/button-mark-2.png',
    'assets/images/button-mark-3.png',
    'assets/images/button-mark-4.png',
    'assets/images/button-mark-5.png',
    'assets/images/button-mark-6.png',
    'assets/images/board.png',
    'assets/images/bg3.jpg',
    'assets/images/button-gray.png',
  ];

  Future<void> precacheAssets(BuildContext context) async {
    if (!areAssetsPrecached) {
      final futures = <Future>[];
      for (var next in assetImages) {
        futures.add(precacheImage(new AssetImage(next), context));
      }
      await Future.wait(futures);
      areAssetsPrecached = true;
      _onPrecachingDone.add(null);
    }
  }
}