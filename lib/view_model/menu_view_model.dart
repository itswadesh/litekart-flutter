import 'package:anne/view/menu/home.dart';
import 'package:anne/view/menu/manage_order.dart';
import 'package:anne/view/menu/mega_menu.dart';
import 'package:anne/view/menu/my_profile.dart';
import 'package:anne/view/menu/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../enum/menu_item_source.dart';
import '../../model/menu_item.dart';


class MenuViewModel extends ChangeNotifier {



  List<MenuItem> _menus = [
  MenuItem(MenuItemSource.home, FontAwesomeIcons.home),
  MenuItem(MenuItemSource.shop_by_category, FontAwesomeIcons.boxes),
  MenuItem(MenuItemSource.manage_order, FontAwesomeIcons.shoppingBag,),
  MenuItem(MenuItemSource.wishlist, FontAwesomeIcons.heart,),
  MenuItem(MenuItemSource.profile, FontAwesomeIcons.userCircle),
  ];
  int _currentIndex = 0;

 List _pageList = [
    Home(),
    MegaMenu(),
    ManageOrder(),
    Wishlist(),
    MyProfile()
  ];

  List get pageList => _pageList;
  int get currentIndex => _currentIndex;

  List<MenuItem> get menus => _menus;

  updateIndex(index){
    _currentIndex = index;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
