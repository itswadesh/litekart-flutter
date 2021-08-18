import 'package:flutter/material.dart';

class NavigationService<T, U> {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  Future<T> pushNamed(String routeName, {Object args}) async {
    return await navigationKey.currentState.pushNamed<T>(
      routeName,
      arguments: args,
    );
  }

  Future<T> push(Route<T> route) async {
    return await navigationKey.currentState.push<T>(route);
  }

  Future<T> pushReplacementNamed(String routeName, {Object args}) async {
    return await navigationKey.currentState.pushReplacementNamed<T, U>(
      routeName,
      arguments: args,
    );
  }

  Future<T> pushNamedAndRemoveUntil(String routeName, {Object args}) async {
    return await navigationKey.currentState.pushNamedAndRemoveUntil<T>(
      routeName,
      (Route<dynamic> route) => false,
      arguments: args,
    );
  }

  Future<T> pushNamedAndRemoveUntilWithRoute(String routeName,
      {Object args}) async {
    return await navigationKey.currentState.pushNamedAndRemoveUntil<T>(
      routeName,
      (Route<dynamic> route) =>
          route.isCurrent && route.settings.name == routeName ? false : true,
      arguments: args,
    );
  }

  Future<bool> maybePop([Object args]) async {
    return await navigationKey.currentState.maybePop<bool>(args);
  }

   pop()  {
    return navigationKey.currentState.pop();
  }

  bool canPop() => navigationKey.currentState.canPop();

  void goBack({T result}) => navigationKey.currentState.pop<T>(result);
}
