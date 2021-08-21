
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';

import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/view_model/menu_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anne/values/route_path.dart' as routes;

class Menu extends StatefulWidget{
  final model;
  Menu(this.model);
  @override
  State<StatefulWidget> createState() {
    return _MenuState();
  }
}

class _MenuState extends State<Menu>{

  MenuViewModel model;
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
                       color: Color.fromRGBO(100, 110, 120, 1.0)))),
           child: Consumer<ProfileModel>(builder: (context,value,view){
             return BottomNavigationBar(
                selectedLabelStyle: TextStyle(color: Color(0xff000000)),
                 unselectedLabelStyle: TextStyle(color: Color(0xff656565)),
                 selectedIconTheme: IconThemeData(color: Color(0xff000000)),
                 unselectedIconTheme: IconThemeData(color: Color(0xff656565)),
                 currentIndex:
                 model.currentIndex,
                 onTap: (int index) {
                  if(value.user==null && (index==3 || index==2 || index==4)){
                    locator<NavigationService>().pushNamed(routes.LoginRoute);
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
        menu.add(BottomNavigationBarItem(icon: Icon(model.menus[i].asset),label: model.menus[i].title,));
    }
    return menu;
  }
}