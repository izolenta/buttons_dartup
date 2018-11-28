import 'package:buttons/services/audio_service.dart';
import 'package:buttons/services/game_service.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:flutter/widgets.dart';

class SwitchColorButton extends StatefulWidget {

  final int color;

  SwitchColorButton({Key key, this.color}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new SwitchColorButtonState();
}

class SwitchColorButtonState extends State<SwitchColorButton> with SubscriberMixin, DimensionHelper {

  GameService _service = getInjected<GameService>();
  AudioService _audio = getInjected<AudioService>();

  bool get _isActive => _service.currentActiveColor != widget.color;

  SwitchColorButtonState() {
    subscriptions.add(_service.onStateChanged.listen((_) => setState(() => {})));
  }

  @override
  Widget build(BuildContext context) {
    var child;
    final image = Image.asset(
      'assets/images/button-mark-${widget.color+1}.png',
      height: 54.0 * getFactor(context),
      width: 54.0 * getFactor(context),
      color: _isActive && _service.isInProgress? Color(0x00000000): Color(0xcc000000),
      colorBlendMode: BlendMode.darken,
    );

    if (!_isActive && _service.isInProgress) {
      child = Transform(
        transform: Matrix4.diagonal3Values(0.8, 0.8, 1.0),
        alignment: FractionalOffset.center,
        child: image,
      );
    }
    else {
      child = image;
    }

    final detector = GestureDetector(
      child: child,
      onTapDown: (_) {
        if (_isActive && _service.isInProgress) {
          _service.makeTurn(widget.color);
          _audio.playButtonSound();
        }
      },
    );

    return Container(
      child: detector,
      width: 60.0 * getFactor(context),
    );
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
}