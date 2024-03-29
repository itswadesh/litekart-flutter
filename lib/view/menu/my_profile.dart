import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/view_model/address_view_model.dart';
import 'package:anne/view_model/cart_view_model.dart';
import 'package:anne/view_model/manage_order_view_model.dart';
import 'package:anne/view_model/schedule_view_model.dart';
import 'package:anne/view_model/wishlist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../../components/base/tz_dialog.dart';
import '../../enum/tz_dialog_type.dart';
import '../../utility/graphQl.dart';
import '../../values/colors.dart';
import '../../view_model/auth_view_model.dart';
import '../../view/cart_logo.dart';
import '../../values/route_path.dart' as routes;
class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();


  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  void initState() {
    if (Provider.of<ProfileModel>(context, listen: false).user == null) {
      Provider.of<ProfileModel>(context, listen: false).getProfile();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Consumer<ProfileModel>(
        builder: (BuildContext context, value, Widget? child) {return Text(
            value.user?.firstName??"User Profile",
            style: TextStyle(
                color: Color(0xff757575),
                fontSize: ScreenUtil().setSp(
                  21,
                ),
                fontWeight:FontWeight.w600
            ),
            textAlign: TextAlign.center,
          );})
        ),
        body: GraphQLProvider(
            client: graphQLConfiguration.initailizeClient(),
            child: CacheProvider(
                child: Container(
                    color: Color(0xfff5f5f5),
                    height: MediaQuery.of(context).size.height,
                    child: Consumer<ProfileModel>(
                        builder: (BuildContext context, value, Widget? child) {
                      return SingleChildScrollView(
                          child: Container(
                        child: Column(
                          children: [
                            Image.asset("assets/images/backgroundProfile.jpg",width: MediaQuery.of(context).size.width,height: ScreenUtil().setWidth(200),fit: BoxFit.cover,),
                            Transform.translate(offset: Offset(0,ScreenUtil().setWidth(-60)),
                              child: Column(children :[ Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: ScreenUtil().setWidth(20),),
                                    InkWell(
                                        onTap: (){
                                        },
                                        child: Container(
                                          height: ScreenUtil().setWidth(120),
                                          width: ScreenUtil().setWidth(120),
                                          child: Card(
                                            child: Container(
                                              height: ScreenUtil().setWidth(120),
                                              width: ScreenUtil().setWidth(120),
                                              child: value.user!.avatar!=null&&value.user!.avatar!=""? Image.network(value.user!.avatar!, fit: BoxFit.cover,):Image.asset("assets/images/user.png", fit: BoxFit.cover,)
                                            ),
                                          ),)),
                                    SizedBox(width: ScreenUtil().setWidth(20),),
                                   // Transform.translate(offset: Offset(0,ScreenUtil().setWidth(18)),
                                      //child:
                                     Column(children:[
                                       SizedBox(height: ScreenUtil().setWidth(70),),
                                       Container(
                                        width: ScreenUtil().setWidth(250),
                                        child: Text(value.user!.firstName??"User",style: TextStyle(fontSize: ScreenUtil().setWidth(20),fontWeight: FontWeight.w600),)
                          ),
                                     ]
                              )
                                  ],
                                ),
                              ),
                                SizedBox(height: ScreenUtil().setWidth(20),),
                            getTiles("Orders","Check Your Order Status",Icons.shopping_bag_outlined,routes.ManageOrder),
                            Divider(),
                                getTiles("Wishlist","Your most Loved Products",Icons.favorite_border_outlined,routes.Wishlist),
                           Divider(),
                            getTiles("Address","Save Addresses for Checkout",Icons.add_location_outlined,routes.ManageAddress),
                                Divider(),
                            getTiles("Profile Details","Change Your Profile Details",Icons.edit,routes.ProfileEditRoute),
                                Divider(),
                                getTiles("Schedule Calls","Check your Upcoming Scheduled Calls",Icons.video_call_outlined,routes.ScheduleDemoList),
                                Divider(),
                                SizedBox(height: ScreenUtil().setWidth(15),),
                                InkWell(
                                  onTap: () async {
                                   await value.removeProfile();
                                   Provider.of<AddressViewModel>(context,listen: false).changeStatus("loading");
                                   Provider.of<WishlistViewModel>(context,listen: false).changeStatus("loading");
                                   Provider.of<OrderViewModel>(context,listen: false).refreshOrderPage();
                                   Provider.of<ScheduleViewModel>(context,listen: false).changeStatus("loading");
                                   Provider.of<CartViewModel>(context,listen: false).changeStatus("loading");
                                   locator<NavigationService>().pushNamedAndRemoveUntil(routes.HomeRoute);
                                  },
                                  child: Container(
                                    height: 43,
                                    width: MediaQuery.of(context).size.width * 0.80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.primaryElement, width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Log Out",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.primaryElement,
                                            fontWeight: FontWeight.w600,
                                            fontSize: ScreenUtil().setSp(16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
]))]
                        ),
                        ),
                      );
                    })))));
  }

  getTiles(String title, String subtitle, IconData icon, String path) {
    return ListTile(
      onTap: (){
        if(path == routes.Wishlist || path == routes.ManageOrder){
          locator<NavigationService>().pushNamed(path);
        }
        else{
          locator<NavigationService>().pushNamed(path);
        }
      },
      leading: Icon(icon,color: Color(0xff616161),size: ScreenUtil().setWidth(28)),
      title: Text(title,style: TextStyle(fontSize: ScreenUtil().setSp(18)),),
      subtitle: Text(subtitle, style: TextStyle(fontSize: ScreenUtil().setSp(14)),),
      trailing: Icon(FontAwesomeIcons.angleRight,color: Color(0xff616161),size: ScreenUtil().setWidth(22),),
    );
  }
}
