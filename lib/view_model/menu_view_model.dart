import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:anne/values/route_path.dart' as routes;
import 'package:anne/enum/menu_item_source.dart';
import 'package:anne/model/menu_item.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';

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
      MenuItem(MenuItemSource.manage_order, FontAwesomeIcons.shoppingBag,
          () {
        _navigationService.pushNamed(routes.ManageOrder);
      }),
      MenuItem(
          MenuItemSource.manage_address, FontAwesomeIcons.mapMarkedAlt,
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
