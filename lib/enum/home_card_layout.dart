
import 'package:anne/values/functions.dart';

enum HomeCardLayout { Single, Grid, List }

HomeCardLayout getHomeCardLayoutFromString(String layout) {
  if (layout != null) {
    layout = "HomeCardLayout.${formatString(layout)}";
    return HomeCardLayout.values
        .firstWhere((f) => f.toString() == layout, orElse: () => null);
  } else {
    return null;
  }
}

enum HomeRouteType { App, Url, Api }

HomeRouteType getHomeRouteTypeFromString(String route) {
  if (route != null) {
    route = "HomeRouteType.${formatString(route)}";
    return HomeRouteType.values
        .firstWhere((f) => f.toString() == route, orElse: () => null);
  } else {
    return null;
  }
}