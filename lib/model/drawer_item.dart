import 'package:flutter/material.dart';
import '../../enum/drawer_item_source.dart';

class DrawerItem {
  DrawerItemSource source;
  IconData asset;
  VoidCallback onTap;

  String? get title => mapping[source];

  DrawerItem(this.source, this.asset, this.onTap);

  Map<String, dynamic> toJson() =>
      {'source': source, 'asset': asset, 'on_tap': onTap.toString()};

  Map<DrawerItemSource, String> mapping = {
    DrawerItemSource.my_profile: 'My Profile',
    DrawerItemSource.shop_by_category: 'Shop By Category',
    DrawerItemSource.manage_address: 'Manage Address',
    DrawerItemSource.manage_order: 'Manage Order',
    DrawerItemSource.wishlist: 'Wishlist'
  };
}
