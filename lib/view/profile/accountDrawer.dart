import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../values/route_path.dart' as routes;
import '../../view_model/auth_view_model.dart';

class AccountDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountDrawer();
  }
}

class _AccountDrawer extends State<AccountDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    size: 28,
                  ),
                )
              ],
            ),
          ),
          _createHeader(),
          SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: 15,
          ),
          _createDrawerItem(icon: Icons.dashboard, text: "Dashboard"),
          _createDrawerItem(
              icon: Icons.person_pin,
              text: "Profile Information",
              onTap: () {
                locator<NavigationService>().pushNamed(routes.ProfileInfoRoute);
              }),
          _createDrawerItem(icon: Icons.favorite, text: "Wishlist"),
          _createDrawerItem(
            icon: Icons.credit_card, text: "Saved Cards",
            //   onTap: (){
            // deleteCookieFromSF();
            // token = "";
            // profileData = "";
            // Navigator.of(context)
            //   .pushNamedAndRemoveUntil('/signIn', (Route<dynamic> route) => false);}
          ),
          _createDrawerItem(icon: Icons.list, text: "My Reviews"),
          _createDrawerItem(icon: Icons.power_settings_new, text: "Wishlist"),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return Consumer<ProfileModel>(builder: (context, user, child) {
      return Container(
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Container(
              margin: EdgeInsets.all(3),
              width: 60.0,
              height: 60.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image:
                          //profileData['avatar'] != null?NetworkImage(baseUrl+profileData['avatar']) :
                          user.user.avatar != null
                              ? NetworkImage(user.user.avatar)
                              : AssetImage("assets/images/user.png")))),
          SizedBox(
            height: 15,
          ),
          Text(
            "Hello ${user.user.firstName ?? "User1"}",
            style: TextStyle(color: Color(0xffee7625), fontSize: 25),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "${user.user.email ?? "email@tablez.com"}",
            style: TextStyle(color: Colors.grey, fontSize: 17),
          ),
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
}
