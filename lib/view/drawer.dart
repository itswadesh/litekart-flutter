import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/menu_item.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../values/radii.dart';
import '../../view_model/auth_view_model.dart';
import '../../view_model/home_view_model.dart';
import '../../view_model/menu_view_model.dart';
import '../../values/route_path.dart' as routes;

class Drawer extends StatefulWidget {
  final HomeViewModel model;

  Drawer(this.model);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> with SingleTickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();

  Widget menuTiles(MenuItem menu, MenuViewModel model) {
    return GestureDetector(
      onTap: (Provider.of<ProfileModel>(context, listen: false).user == null &&
              menu.title != "Shop By Category")
          ? () {
              _navigationService.pushNamed(routes.LoginRoute);
            }
          : menu.onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: Radii.k10pxRadius),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: Icon(
                    menu.asset,
                    size: 16,
                    color: Color(0xFFb26d11),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  menu.title,
                  maxLines: 2,
                  style: TextStyle(
                      color: Color(0xFF5C5C5C),
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
                Expanded(child: Container())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: GestureDetector(
        onTap: () async {
          _navigationService.pushNamed(routes.LoginRoute);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.signInAlt,
              color: Color(0xFF5C5C5C),
              size: 19,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xFF5C5C5C),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: GestureDetector(
        onTap: () async {
          await showDeleteDialog(
              "Confirmation", "Do you want to logout ?", context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.signOutAlt,
              color: Color(0xFF5C5C5C),
              size: 19,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              'Logout',
              style: TextStyle(
                  color: Color(0xFF5C5C5C),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget menuBody(HomeViewModel model) {
    return Stack(
      children: [
        ChangeNotifierProvider(
          create: (BuildContext context) => MenuViewModel(context),
          child: Consumer<MenuViewModel>(
            builder: (context, model, child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.withOpacity(0.15),
                padding: EdgeInsets.all(10),
                //height: MediaQuery.of(context).size.height,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.68,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: model.menus.length + 1,
                      itemBuilder: (context, index) {
                        if (index < model.menus.length) {
                          MenuItem _item = model.menus[index];
                          return menuTiles(_item, model);
                        } else
                          return Provider.of<ProfileModel>(context,
                                          listen: false)
                                      .user ==
                                  null
                              ? loginButton()
                              : logoutButton();
                      },
                      /*staggeredTileBuilder: (int index) {
                          return new StaggeredTile.fit(1);
                        },*/
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 14, bottom: 30),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.black38),
            child: InkWell(
                borderRadius: Radii.k24pxRadius,
                onTap: () {
                  model.resize();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    FontAwesomeIcons.times,
                    color: Colors.white,
                  ),
                )),
          ),
        )
      ],
    );
  }

  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    offset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.0, 0.0),
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.isDrawerOpen) {
      controller.reverse();
    } else {
      controller.forward();
    }
    return Scaffold(
      backgroundColor: Color(0xFFeff0f2),
      /*appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Menu',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF5C5C5C)),
          ),
          actions: [
            InkWell(
              onTap: () async {
                bool value = await showDeleteDialog(
                    "Confirmation", "Do you want to logout ?", context);
                if (value) {
                  bool result = await (User()).delete();
                  if (result) {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else {
                      _navigationService
                          .pushNamedAndRemoveUntil(routes.LoginRoute);
                    }
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.height * 0.08,
                height: MediaQuery.of(context).size.height * 0.07,
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF686868),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            )
          ]),*/
      body: SlideTransition(position: offset, child: menuBody(widget.model)),
    );
  }

  showDeleteDialog(String s, String t, BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(t),
          actions: [
            InkWell(
              child: Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: Text("Yes")),
              onTap: () async {
                await Provider.of<ProfileModel>(context, listen: false)
                    .removeProfile();
                if (Platform.isAndroid) {
                  widget.model.resize();
                  Navigator.of(context).pop();
                } else {
                  _navigationService.pushNamedAndRemoveUntil(routes.LoginRoute);
                }
              },
            ),
            InkWell(
              child: Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: Text("No")),
              onTap: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
