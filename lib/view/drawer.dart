import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/view_model/menu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../values/route_path.dart' as routes;

class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeDrawer();
  }
}

class _HomeDrawer extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createMenuDrawerItem(
              icon: FontAwesomeIcons.boxes,
              text: "Shop By Categories",
              routePath: routes.MegaMenuRoute),
          Divider(
            height: 0.5,
            thickness: 0.4,
          ),
          _createMenuDrawerItem(
              icon: FontAwesomeIcons.shoppingBag, text: "Orders", routePath: routes.ManageOrder),
          Divider(
            height: 0.5,
            thickness: 0.4,
          ),
          _createMenuDrawerItem(
              icon: FontAwesomeIcons.heart, text: "Wishlist", routePath: routes.Wishlist),
          Divider(
            height: 0.5,
            thickness: 0.4,
          ),
          _createMenuDrawerItem(
              icon: FontAwesomeIcons.userCircle,
              text: "Profile Information",
              routePath: routes.MyProfile),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return Consumer<ProfileModel>(builder: (context, user, child) {
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/backgroundProfile.jpg",),
            fit: BoxFit.fill
            )),
        child: Column(children: [
          SizedBox(
            height: ScreenUtil().setWidth(55),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                    height: ScreenUtil().setWidth(90),
                    width: ScreenUtil().setWidth(90),
                    child: Card(
                      child: Container(
                          height: ScreenUtil().setWidth(90),
                          width: ScreenUtil().setWidth(90),
                          child: (user.user !=null && user.user.avatar != null)
                              ? Image.network(user.user.avatar,fit: BoxFit.contain,height: ScreenUtil().setWidth(90),
                            width: ScreenUtil().setWidth(90),)
                              : Image.asset("assets/images/user.png",fit: BoxFit.contain,height: ScreenUtil().setWidth(90),
                            width: ScreenUtil().setWidth(90),)),
                    ),
                  )),
              SizedBox(width: ScreenUtil().setWidth(20),),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(17)),
                width: double.infinity,
                child: Text(
                  "${user.user!=null?(user.user.firstName ?? "User"):"User"}",
                  style: TextStyle(color: Color(0xff454545), fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'Sofia'),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),

          SizedBox(
            height: ScreenUtil().setWidth(15),
          )
        ]),
      );
    });
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
          title:
              //   Text(text, style: ThemeApp().textThemeGrey(),),
              Text(text,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                  textAlign: TextAlign.left),
          onTap: onTap,
        ));
  }

  Widget _createMenuDrawerItem({IconData icon, String text, String routePath}) {
    return Consumer<MenuViewModel>(builder: (context, model, child) {
      return Container(
          padding: EdgeInsets.only(left: 10),
          child: ListTile(
              leading: Icon(
                icon,
                color: Colors.black,
                size: 20,
              ),
              title:
                  //   Text(text, style: ThemeApp().textThemeGrey(),),
                  Text(text,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                      textAlign: TextAlign.left),
              onTap: () {
               locator<NavigationService>().pushNamedAndRemoveUntil(routePath);
               // locator<NavigationService>().pushNamed(routes.HomeRoute);
              }));
    });
  }
}
