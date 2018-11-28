import 'package:buttons/models/board_configuration.dart';
import 'package:buttons/models/difficulty.dart';
import 'package:buttons/services/game_service.dart';
import 'package:buttons/util/dimension_helper.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/widgets/menus/menu_button.dart';
import 'package:buttons/widgets/menus/rolling_menu_section.dart';
import 'package:flutter/widgets.dart';

class GameMenu extends StatefulWidget {

  final VoidCallback onPressStart;

  const GameMenu({Key key, this.onPressStart}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> with DimensionHelper {

  final GameService _service = getInjected<GameService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        RollingMenuSection(
          caption: 'Board Size',
          captionFontSize: (36 * getFactor(context)).floor(),
          captionColor: Color(0xFFc5060b),
          options: ['7x7', '10x10', '15x15'],
          selectedOption: BoardConfiguration.boardSizes.indexOf(_service.boardConfig.squareSize),
          optionColor: Color(0xFF1ea0cb),
          optionFontSize: (24 * getFactor(context)).floor(),
          onRoll: (option) => _service.changeSize(option),
        ),
        RollingMenuSection(
          caption: 'Difficulty',
          captionFontSize: (36 * getFactor(context)).floor(),
          captionColor: Color(0xFFc5060b),
          options: ['Easy', 'Medium', 'Hard'],
          selectedOption: Difficulty.stringValues.indexOf(_service.boardConfig.difficulty.stringValue),
          optionColor: Color(0xFF1ea0cb),
          optionFontSize: (24 * getFactor(context)).floor(),
          onRoll: (option) => _service.changeDifficulty(option),
        ),
        MenuButton(
          child: Text('Start!', style: TextStyle(fontFamily: 'LuckiestGuy', fontSize: 36 * getFactor(context), color: Color(0xFFc5060b))),
          onPress: widget.onPressStart,
        )
      ],
    );
  }

}