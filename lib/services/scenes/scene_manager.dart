import 'dart:async';

import 'package:buttons/services/scenes/scene_state.dart';

class SceneManager {

  SceneState _sceneState;
  // ignore: close_sinks
  StreamController<void> _onSceneStateChangedController = new StreamController<void>.broadcast();
  Stream get onSceneStateChanged => _onSceneStateChangedController.stream;

  bool get isLoadingState => _sceneState == SceneState.loadingScene;
  bool get isMenuState => _sceneState == SceneState.menuScene;
  bool get isGameState => _sceneState == SceneState.gameScene;

  SceneManager() {
    _sceneState = SceneState.loadingScene;
  }

  void switchToGameScene() {
    _switchScene(SceneState.gameScene);
  }

  void switchToMenuScene() {
    _switchScene(SceneState.menuScene);
  }

  void _switchScene(SceneState scene) {
    _sceneState = scene;
    _onSceneStateChangedController.add(null);
  }

}