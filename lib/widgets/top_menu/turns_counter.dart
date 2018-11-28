import 'package:buttons/services/game_service.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:flutter/widgets.dart';

class TurnsCounter extends StatefulWidget {
  @override
  State<TurnsCounter> createState() => _TurnsCounterState();

}

class _TurnsCounterState extends State<TurnsCounter> with SubscriberMixin, DimensionHelper {

  GameService _service;

  @override
  void initState() {
    super.initState();
    _service = getInjected<GameService>();
    subscriptions.add(_service.onStateChanged.listen((_) => setState(() => {})));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: getWidth(context) * 0.32,
      top: getHeight(context) * 0.03,
      child: Text(
        'Turns: ${_service.turns}',
        style: TextStyle(
          fontFamily: 'LuckiestGuy',
          fontSize: 22.0 * getFactor(context),
          color: Color(0xffd9121f),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
}