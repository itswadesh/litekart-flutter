import '../../values/functions.dart';
import 'package:collection/collection.dart' show IterableExtension;

enum HomeCardLayout { Single, Grid, List }

HomeCardLayout? getHomeCardLayoutFromString(String layout) {
  if (layout != null) {
    layout = "HomeCardLayout.${formatString(layout)}";
    return HomeCardLayout.values
        .firstWhereOrNull((f) => f.toString() == layout);
  } else {
    return null;
  }
}

enum HomeRouteType { App, Url, Api }

HomeRouteType? getHomeRouteTypeFromString(String? route) {
  if (route != null) {
    route = "HomeRouteType.${formatString(route)}";
    return HomeRouteType.values
        .firstWhereOrNull((f) => f.toString() == route);
  } else {
    return null;
  }
}
