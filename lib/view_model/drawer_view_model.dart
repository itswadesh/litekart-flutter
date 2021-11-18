import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../values/route_path.dart' as routes;
import '../../enum/drawer_item_source.dart';
import '../../model/drawer_item.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';

class DrawerViewModel extends ChangeNotifier {
  final BuildContext context;
  final NavigationService? _navigationService = locator<NavigationService>();
  List<DrawerItem>? _drawers;

  DrawerViewModel(this.context) {
    setDrawer();
  }

  List<DrawerItem>? get drawers => _drawers;

  void setDrawer() {
    _drawers = [
      DrawerItem(DrawerItemSource.my_profile, FontAwesomeIcons.userCircle, () {
        _navigationService!.pushNamed(routes.MyProfile);
      }),
      DrawerItem(
          DrawerItemSource.shop_by_category, FontAwesomeIcons.shoppingCart,
              () {
            _navigationService!.pushNamed(routes.MegaMenuRoute);
          }),
      DrawerItem(DrawerItemSource.manage_order, FontAwesomeIcons.shoppingBag,
              () {
            _navigationService!.pushNamed(routes.ManageOrder);
          }),
      DrawerItem(
          DrawerItemSource.manage_address, FontAwesomeIcons.mapMarkerAlt,
              () {
            _navigationService!.pushNamed(routes.ManageAddress);
          }),
      DrawerItem(DrawerItemSource.wishlist, FontAwesomeIcons.heart, () {
        _navigationService!.pushNamed(routes.Wishlist);
      }),
    ];
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
