import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Future<T> push<T>(
    Widget screen, {
    bool fullscreenDialog: false,
    bool rootNavigator: false,
    bool maintainState: true,
    RouteSettings settings,
  }) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).push(
      MaterialPageRoute(
        builder: (context) => screen,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      ),
    );
  }

  void popUntil<T>({
    String to,
    bool rootNavigator: false,
  }) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).popUntil(
      ModalRoute.withName(to ?? '/'),
    );
  }

  Future<T> pushAndRemoveUntil<T>(
    Widget screen, {
    String to,
    bool fullscreenDialog: false,
    bool rootNavigator: false,
    bool maintainState: true,
    RouteSettings settings,
  }) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => screen,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      ),
      ModalRoute.withName(to ?? '/'),
    );
  }

  bool pop<T extends Object>([T result]) {
    return Navigator.of(this).pop<T>(result);
  }

  Future<T> replace<T, TO>(
    Widget screen, {
    bool rootNavigator: false,
    RouteSettings settings,
    bool maintainState: true,
    bool fullscreenDialog: false,
    TO result,
  }) {
    return Navigator.of(this, rootNavigator: rootNavigator).pushReplacement(
      MaterialPageRoute(
        builder: (context) => screen,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      ),
      result: result,
    );
  }

  Future<T> resetTo<T>(
    Widget screen, {
    String title,
    RouteSettings settings,
    bool maintainState: true,
    bool stacked: false,
    bool fullscreenDialog: false,
  }) {
    return Navigator.of(this, nullOk: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => screen,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      ),
      (_) => false,
    );
  }
}
