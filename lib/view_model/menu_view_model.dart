import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../values/route_path.dart' as routes;
import '../../enum/menu_item_source.dart';
import '../../model/menu_item.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';

class MenuViewModel extends ChangeNotifier {
  final BuildContext context;
  final NavigationService _navigationService = locator<NavigationService>();
  List<MenuItem> _menus;

  MenuViewModel(this.context) {
    setMenu();
  }

  List<MenuItem> get menus => _menus;

  void setMenu() {
    _menus = [
      MenuItem(MenuItemSource.my_profile, FontAwesomeIcons.userCircle, () {
        _navigationService.pushNamed(routes.MyProfile);
      }),
      MenuItem(
          MenuItemSource.shop_by_category, FontAwesomeIcons.shoppingCart,
          () {
        _navigationService.pushNamed(routes.MegaMenuRoute);
      }),
      MenuItem(MenuItemSource.manage_order, FontAwesomeIcons.shoppingBag,
          () {
        _navigationService.pushNamed(routes.ManageOrder);
      }),
      MenuItem(
          MenuItemSource.manage_address, FontAwesomeIcons.mapMarkerAlt,
          () {
        _navigationService.pushNamed(routes.ManageAddress);
      }),
      MenuItem(MenuItemSource.wishlist, FontAwesomeIcons.heart, () {
        _navigationService.pushNamed(routes.Wishlist);
      }),
    ];
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
