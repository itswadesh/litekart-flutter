import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  final BuildContext buildContext;
  double xOffset = 0;
  double zOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  HomeViewModel(this.buildContext);

  void resize() {
    if (isDrawerOpen) {
      xOffset = 0;
      zOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    } else {
      xOffset = MediaQuery.of(buildContext).size.width * 0.78;
      zOffset = MediaQuery.of(buildContext).size.width * 0.68;
      yOffset = MediaQuery.of(buildContext).size.height * 0.073;
      scaleFactor = 0.9;
      isDrawerOpen = true;
    }
    notifyListeners();
  }
}
