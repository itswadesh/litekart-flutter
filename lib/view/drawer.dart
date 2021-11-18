import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/graphQl.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/view_model/menu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../main.dart';
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
              icon: Icons.category_outlined,
              text: "Shop By Categories",
              routePath: routes.MegaMenuRoute),
          Divider(
            height: 0.5,
            thickness: 0.4,
          ),
          _createMenuDrawerItem(
              icon: Icons.shopping_bag_outlined, text: "Orders", routePath: routes.ManageOrder),
          Divider(
            height: 0.5,
            thickness: 0.4,
          ),
          _createMenuDrawerItem(
              icon: Icons.favorite_border_outlined, text: "Wishlist", routePath: routes.Wishlist),
          Divider(
            height: 0.5,
            thickness: 0.4,
          ),
          _createMenuDrawerItem(
              icon: Icons.person_outline,
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
                          child: (user.user !=null && user.user!.avatar != null)
                              ? Image.network(user.user!.avatar!,fit: BoxFit.contain,height: ScreenUtil().setWidth(90),
                            width: ScreenUtil().setWidth(90),)
                              : Image.asset("assets/images/user.png",fit: BoxFit.contain,height: ScreenUtil().setWidth(90),
                            width: ScreenUtil().setWidth(90),)),
                    ),
                  )),

            ],
          ),
          SizedBox(height: ScreenUtil().setWidth(20),),
          InkWell(
            onTap: (){
              if(token!=null && token!="") {
                locator<NavigationService>().pushNamed(
                    routes.MyProfile);
              }
              else {
                if (settingData!.otpLogin!) {
                  locator<NavigationService>().pushNamed(routes.LoginRoute);
                }
                else {
                  locator<NavigationService>().pushNamed(
                      routes.EmailLoginRoute);
                }
              }
            },
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),

                  child: Text(
                    "${user.user!=null?(user.user!.firstName ?? "User"):"User"}",
                    style: TextStyle(color: Color(0xff616161), fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Inter'),
                    textAlign: TextAlign.left,
                  ),
                ),
      Container(
      padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),

      child:
                Icon(FontAwesomeIcons.angleRight,color: Color(0xff000000),size: ScreenUtil().setWidth(14),),
      ) ],),

          ),

          SizedBox(
            height: ScreenUtil().setWidth(20),
          )
        ]),
      );
    });
  }

  Widget _createMenuDrawerItem({IconData? icon, String? text, String? routePath}) {
    return Consumer<MenuViewModel>(builder: (context, model, child) {
      return Container(

          child: ListTile(
              leading: Icon(
                icon,
                color: Color(0xff616161),
                size: 22,
              ),
              title:
                  //   Text(text, style: ThemeApp().textThemeGrey(),),
                 Transform.translate(offset: Offset(-ScreenUtil().setWidth(25),0), child: Text(text!,
                      style: TextStyle(color: Color(0xff616161), fontSize: 16),
                      textAlign: TextAlign.left)),
              onTap: () {
                if(text=="Shop By Categories") {
                  locator<NavigationService>().pushNamed(
                      routePath!);
                }
                else{
                  if(token!=null && token!=""){
                    locator<NavigationService>().pushNamed(
                        routePath!);
                  }
                  else{

                if (settingData!.otpLogin!) { locator<NavigationService>().pushNamed(routes.LoginRoute);}
                else{
                locator<NavigationService>().pushNamed(routes.EmailLoginRoute);
                }
                }
                  }
                // locator<NavigationService>().pushNamed(routes.HomeRoute);
      }));
    });
  }
}
