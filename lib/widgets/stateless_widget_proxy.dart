//a dirty hack because of https://github.com/dart-lang/sdk/issues/31543
import 'package:flutter/widgets.dart';

class StatelessWidgetProxy extends StatelessWidget {
  @override
  Widget build(BuildContext context) => null;
}