import 'package:flutter/material.dart';
import '../../enum/menu_item_source.dart';

class MenuItem {
  MenuItemSource source;
  IconData asset;

  String get title => mapping[source];

  MenuItem(this.source, this.asset);

  Map<String, dynamic> toJson() =>
      {'source': source, 'asset': asset};

  Map<MenuItemSource, String> mapping = {
    MenuItemSource.home: 'Home',
    MenuItemSource.shop_by_category: 'Categories',
    MenuItemSource.liveCommerce: 'Live',
    MenuItemSource.manage_order: 'Orders',
    MenuItemSource.profile:'Profile'
  };
}
