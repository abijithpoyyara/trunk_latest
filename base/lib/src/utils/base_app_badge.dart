import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class AppBadgeMixin {
  _AppBadge _appBadge;

  initBadge() {
    _appBadge = _AppBadge();
    _appBadge.initPlatformState();
  }

  void markRead({int count = 1}) {
    _appBadge.markAsRead(count);
  }

  void updateNotificationCount({int count = 1}) {
    _appBadge.addNotificationCount(count);
  }
}

class _AppBadge {
  static final _AppBadge _instance = _AppBadge._single();

  bool _appBadgeSupported;
  int _count;

  _AppBadge._single() {
    _appBadgeSupported = false;
    _count = 0;
  }

  factory _AppBadge() {
    return _instance;
  }

  initPlatformState() async {
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        _appBadgeSupported = true;
      } else {
        _appBadgeSupported = false;
      }
    } on PlatformException {
      _appBadgeSupported = false;
    }
  }

  void addNotificationCount(int count) {
    if (!_appBadgeSupported) return;
    _count += count;
    if (_count > 0)
      _updateBadge(count);
    else
      _removeBadge();
  }

  void markAsRead(int count) {
    if (!_appBadgeSupported) return;

    _count -= count;
    if (_count > 0)
      _updateBadge(count);
    else
      _removeBadge();
  }

  void _updateBadge(int count) {
    FlutterAppBadger.updateBadgeCount(count);
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }
}
