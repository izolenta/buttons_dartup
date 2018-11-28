import 'package:flutter/widgets.dart';

abstract class DimensionHelper {
  double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
  double getHeight(BuildContext context) => MediaQuery.of(context).size.height;
  double getFactor(BuildContext context) => getWidth(context) / 400;
}