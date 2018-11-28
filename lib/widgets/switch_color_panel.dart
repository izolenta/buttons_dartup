import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/widgets/stateless_widget_proxy.dart';
import 'package:buttons/widgets/switch_color_button.dart';
import 'package:flutter/widgets.dart';

class SwitchColorPanel extends StatelessWidgetProxy with DimensionHelper {
  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];
    for (int i=0; i<6; i++) {
      buttons.add(SwitchColorButton(color: i));
    }
    return Padding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons,
      ),
      padding: EdgeInsets.only(top: getHeight(context) * 0.051),
    );
  }

}