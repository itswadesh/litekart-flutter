
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/values/colors.dart';

import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/view_model/menu_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:anne/values/route_path.dart' as routes;

import '../main.dart';

class Menu extends StatefulWidget{
  final model;
  Menu(this.model);
  @override
  State<StatefulWidget> createState() {
    return _MenuState();
  }
}

class _MenuState extends State<Menu>{

  late MenuViewModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return  Scaffold(
         body: model.pageList[model.currentIndex],
         bottomNavigationBar: new Theme(
           data: Theme.of(context).copyWith(
               primaryColor: Colors.black,
               canvasColor: Colors.white,
               textTheme: Theme.of(context).textTheme.copyWith(
                   caption: new TextStyle(
                       color: AppColors.primaryElement))),
           child: Consumer<ProfileModel>(builder: (context,value,view){
             return BottomNavigationBar(
                selectedLabelStyle: TextStyle(color: AppColors.primaryElement,fontSize: ScreenUtil().setSp(14)),
                 unselectedLabelStyle: TextStyle(color: Color(0xff616161),fontSize: ScreenUtil().setSp(14)),
                 selectedIconTheme: IconThemeData(color: AppColors.primaryElement),
                 unselectedIconTheme: IconThemeData(color: Color(0xff616161)),
                 selectedItemColor: AppColors.primaryElement,
                 unselectedItemColor: Color(0xff616161),
                 showSelectedLabels: true,
                 showUnselectedLabels: true,
                 selectedFontSize: ScreenUtil().setSp(14),
                 unselectedFontSize: ScreenUtil().setSp(14),
                 iconSize: 22,
                 currentIndex:
                 model.currentIndex,
                 onTap: (int index) {
                  if(value.user==null && (index==3 || index==2 || index==4)){
    if (settingData!.otpLogin!) { locator<NavigationService>().pushNamed(routes.LoginRoute);}
    else{
      locator<NavigationService>().pushNamed(routes.EmailLoginRoute);
    }
                  }
                  else {
                    setState(() {
                      model.updateIndex(index);
                    });
                  }
                 }, // new
                 items: bottomNavigationItem(model)
             );
           })  ,
         ));
  }

  List<BottomNavigationBarItem> bottomNavigationItem(MenuViewModel model){
    List<BottomNavigationBarItem> menu  = [];
    for(int i=0; i< model.menus.length;i++){
        menu.add(BottomNavigationBarItem(icon: Icon(model.menus[i].asset,size: 22,),label: model.menus[i].title,));
    }
    return menu;
  }
}