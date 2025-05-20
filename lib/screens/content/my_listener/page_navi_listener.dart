import 'package:flutter/cupertino.dart';

mixin PageNaviListener {
  void onPageChanged();
}

class PageNaviSubject {
  static final PageNaviSubject instance = PageNaviSubject._();
  PageNaviSubject._();
  factory PageNaviSubject() => instance;

  final List<PageNaviListener> _listener = [];

  void addListener(PageNaviListener pv) {
    if (_listener.contains(pv)) return;
    _listener.add(pv);
  }

  void removeListener(PageNaviListener pv) {
    _listener.remove(pv);
  }

  void notiPageChanged() {
      for (var ev in _listener) {
    try {
      ev.onPageChanged();
    } catch (e, s) {
      debugPrint('notiPageChanged Listener error: $e\n$s');
    }
  }
  }
}
