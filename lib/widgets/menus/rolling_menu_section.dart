import 'package:buttons/widgets/menus/menu_button.dart';
import 'package:flutter/widgets.dart';

class RollingMenuSection extends StatefulWidget {

  final Function onRoll;
  final String caption;
  final List<String> options;
  final int captionFontSize;
  final int optionFontSize;
  final Color captionColor;
  final Color optionColor;
  final int selectedOption;

  const RollingMenuSection({
    Key key,
    this.onRoll,
    this.caption,
    this.options,
    this.captionFontSize,
    this.optionFontSize,
    this.captionColor,
    this.optionColor,
    this.selectedOption: 0
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RollingMenuSectionState();
}

class _RollingMenuSectionState extends State<RollingMenuSection>{

  int selectedOption;

  @override
  void initState() {
    selectedOption = widget.selectedOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = Text(
      widget.caption,
      style: TextStyle(
        fontSize: widget.captionFontSize.toDouble(),
        fontFamily: 'LuckiestGuy',
        color: widget.captionColor
      ),
    );
    final button = MenuButton(child: buttonText, onPress: _rollToNextOption);
    final option = Text(
      widget.options[selectedOption],
      style: TextStyle(
        fontSize: widget.optionFontSize.toDouble(),
        fontFamily: 'LuckiestGuy',
        color: widget.optionColor
      ),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Column(
        children: [
          button,
          option,
        ],
      )
    );
  }

  void _rollToNextOption() {
    setState(() {
      selectedOption = selectedOption == widget.options.length-1? 0 : selectedOption + 1;
      widget.onRoll(selectedOption);
    });
  }
}