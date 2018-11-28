import 'dart:async';

class ContextService {
  // ignore: close_sinks
  StreamController<void> _onTapToStartPressed = new StreamController<void>.broadcast();
  Stream get onTapToStart => _onTapToStartPressed.stream;

  void firePressTapToStart() {
    _onTapToStartPressed.add(null);
  }
}