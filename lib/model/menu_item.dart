import 'package:flutter/material.dart';
import '../../enum/menu_item_source.dart';

class MenuItem {
  MenuItemSource source;
  IconData asset;
  VoidCallback onTap;

  String get title => mapping[source];

  MenuItem(this.source, this.asset, this.onTap);

  Map<String, dynamic> toJson() =>
      {'source': source, 'asset': asset, 'on_tap': onTap.toString()};

  Map<MenuItemSource, String> mapping = {
    MenuItemSource.my_profile: 'My Profile',
    MenuItemSource.shop_by_category: 'Shop By Category',
    MenuItemSource.manage_address: 'Manage Address',
    MenuItemSource.manage_order: 'Manage Order',
    MenuItemSource.wishlist: 'Wishlist'
  };
}
