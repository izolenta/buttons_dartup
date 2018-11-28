import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/widgets/stateless_widget_proxy.dart';
import 'package:buttons/widgets/top_menu/time_counter.dart';
import 'package:buttons/widgets/top_menu/turns_counter.dart';
import 'package:flutter/widgets.dart';

class TopMenuBar extends StatelessWidgetProxy with DimensionHelper {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context),
      height: getHeight(context) * 0.06,
      child: Stack(
        children: [
          Positioned(
            left: getWidth(context) * 0.05,
            top: getHeight(context) * 0.03,
            child: Text(
              'Menu',
              style: TextStyle(
                fontFamily: 'LuckiestGuy',
                fontSize: 22.0 * getFactor(context),
                color: Color(0xff7a3ed1),
              ),
            ),
          ),
          TurnsCounter(),
          TimeCounter(),
        ],
      ),
    );
  }

}