import 'package:buttons/services/audio_service.dart';
import 'package:buttons/services/context_service.dart';
import 'package:buttons/services/database_service.dart';
import 'package:buttons/services/game_service.dart';
import 'package:buttons/services/scenes/scene_manager.dart';
import 'package:buttons/util/inject_helper.dart';
import 'package:buttons/util/precacher.dart';
import 'package:buttons/util/subscriber.dart';
import 'package:buttons/widgets/scenes/game_scene.dart';
import 'package:buttons/widgets/scenes/loading_scene.dart';
import 'package:buttons/widgets/scenes/menu_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {

  final injector = Injector.getInjector();

  final prefs = await SharedPreferences.getInstance();
  final boardType = prefs.getInt('boardType')?? 0;
  final diffType = prefs.getInt('diffType')?? 0;
  injector.map<GameService>((s) =>  GameService(boardType, diffType), isSingleton: true);
  injector.map<AudioService>((s) =>  AudioService(), isSingleton: true);
  injector.map<ContextService>((s) =>  ContextService(), isSingleton: true);
  injector.map<DatabaseService>((s) =>  DatabaseService(), isSingleton: true);
  injector.map<SceneManager>((s) =>  SceneManager(), isSingleton: true);
  injector.map<Precacher>((s) =>  Precacher(), isSingleton: true);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SubscriberMixin {

  final SceneManager _manager = getInjected<SceneManager>();
  final Precacher _precacher = getInjected<Precacher>();

  @override
  void initState() {
    _precacher.precacheAssets(context).then((_) => setState(() {}));
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Screen.keepOn(true);
    subscriptions.add(_manager.onSceneStateChanged.listen((_) => setState(() {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scene;
    if (_manager.isLoadingState) {
      scene = LoadingScene();
    }
    else if (_manager.isMenuState) {
      scene = MenuScene();
    }
    else {
      scene = GameScene();
    }
    return MaterialApp(
      home: scene,
    );
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
}
