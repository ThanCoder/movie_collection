import 'package:flutter/cupertino.dart';

mixin ContentScreenEventListener {
  void onPageChanged(String? pageName) {}
  void onChangedCoverAndPlayer(bool isShowPlayer) {}
  void onPlayVideoPlayer(String source) {}
}

class ContentScreenEventSender {
  static final ContentScreenEventSender instance = ContentScreenEventSender._();
  ContentScreenEventSender._();
  factory ContentScreenEventSender() => instance;

  final List<ContentScreenEventListener> _listener = [];

  void addListener(ContentScreenEventListener event) {
    if (!_listener.contains(event)) {
      _listener.add(event);
    }
  }

  void removeListener(ContentScreenEventListener event) {
    try {
      _listener.remove(event);
    } catch (e) {
      debugPrint('ContentScreenEventSender: ${e.toString()}');
    }
  }

  void pageChanged({String? pageName}) {
    for (var event in _listener) {
      event.onPageChanged(pageName);
    }
  }

  void changeCoverAndPlayer(bool isShowPlayer) {
    for (var event in _listener) {
      event.onChangedCoverAndPlayer(isShowPlayer);
    }
  }

  void playVideoPlayer(String source) {
    for (var event in _listener) {
      event.onPlayVideoPlayer(source);
    }
  }
}
