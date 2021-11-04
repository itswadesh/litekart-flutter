import 'package:anne/view/menu/home.dart';
import 'package:anne/view/menu/liveCommercePage.dart';
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
  MenuItem(MenuItemSource.home, Icons.home_outlined),
  MenuItem(MenuItemSource.shop_by_category, Icons.category_outlined),
  MenuItem(MenuItemSource.liveCommerce, Icons.live_tv,),
 //   MenuItem(MenuItemSource.wishlist, Icons.favorite_border_outlined,),
  MenuItem(MenuItemSource.manage_order, Icons.shopping_bag_outlined,),
  MenuItem(MenuItemSource.profile, Icons.person_outline),
  ];
  int _currentIndex = 0;

 List _pageList = [
    Home(),
    MegaMenu(),
   // Wishlist(),
    LiveCommercePage(),
    ManageOrder(),
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
