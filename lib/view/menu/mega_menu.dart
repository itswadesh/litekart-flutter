import 'dart:math';

import 'package:anne/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../components/widgets/loading.dart';
import '../../response_handler/megaMenuResponse.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../view_model/megamenu_view_model.dart';
import '../../values/route_path.dart' as routes;

class MegaMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MegaMenu();
  }
}

class _MegaMenu extends State<MegaMenu> {
  final List gradientColors = [
    Color(0xfff0c68c),
    //Color(0xffc5c5c5),
    Color(0xffE1FFB5),
    Color(0xffffe4b5),
    Color(0xffe6e6fa)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Categories",
            style: TextStyle(
                color: Color(0xff616161),
                fontSize: ScreenUtil().setSp(
                  21,
                ))),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: getMegaMenu(),
        ),
      ),
    );
  }

  getMegaMenu() {
    return Consumer<MegaMenuViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.status == "loading") {
        Provider.of<MegaMenuViewModel>(context, listen: false).fetchMegaMenu();
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Center(
            child: Loading(),
          ),
        );
      } else if (value.status == "empty") {
        return SizedBox.shrink();
      } else if (value.status == "error") {
        return SizedBox.shrink();
      } else {
        return Container(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: value.topMegaMenuResponse.megamenu.length,
              itemBuilder: (buildContext, index) {
                return GestureDetector(
                    onTap: () {
                      Provider.of<MegaMenuViewModel>(context, listen: false)
                          .selectTopIndex(index);
                    },
                    child: topMenuCard(
                        value.topMegaMenuResponse.megamenu[index],
                        index == value.selectedTopIndex));
              }),
        );
      }
    });
  }

  topMenuCard(MegaMenuResponse megamenu, bool colorStatus) {
    return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().radius(3)),
            color: gradientColors[Random().nextInt(gradientColors.length)],
            // gradient: LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft,
            //   colors: [
            //     gradientColors[Random().nextInt(gradientColors.length)],
            //     gradientColors[Random().nextInt(gradientColors.length)],
            //     gradientColors[Random().nextInt(gradientColors.length)]
            //   ],
            // ),
          ),
          margin: EdgeInsets.only(top: ScreenUtil().setWidth(5)),
          padding: EdgeInsets.only(top: ScreenUtil().setWidth(14),bottom: ScreenUtil().setWidth(14)),
          child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
              title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Container(
                 width: ScreenUtil().setWidth(155),
                 child: Text(megamenu.name, style: TextStyle(color: Color(0xff000000),fontSize: ScreenUtil().setSp(30)),)),
            megamenu.img!=null? Image.network(megamenu.img,width: ScreenUtil().setWidth(100),height: ScreenUtil().setWidth(100),)
            : Image.asset("assets/images/logo.png",width: ScreenUtil().setWidth(100),height: ScreenUtil().setWidth(100))],
          ),
            children: getMenuCard(megamenu.children),
          )),

    );
  }

  getMenuCard(List<MegaMenuChildren1> children) {
    List<Widget> childrenList  = [];

    for(int index=0;index<children.length;index++)
      {
        childrenList.add(Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().radius(10))),
          child:  Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child:  ExpansionTile(
              title: Text(
                children[index].name,
                style: TextStyle(
                    color: AppColors.primaryElement,
                    fontSize: ScreenUtil().setSp(15),
                    fontFamily: "Sofia"),
              ),
              children: getExpansionTileChild(children[index].children))),
        ));
      }

    return childrenList;
  }

  getExpansionTileChild(List<MegaMenuChildren2> children) {
    List<Widget> list = [];
    for (int i = 0; i < children.length; i++) {
      list.add(Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Color(0xffd0d0d0),
                    width: ScreenUtil().setWidth(0.5)))),
        child: ListTile(
            onTap: () {
              locator<NavigationService>().pushNamed(routes.ProductList, args: {
                "searchKey": "",
                "category": children[i].slug,
                "brandName": "",
                "parentBrand": ""
              });
            },
            title: Text(children[i].name,
                style: TextStyle(
                    color: Color(0xff6d6d6d),
                    fontSize: ScreenUtil().setSp(15),
                    fontFamily: "Sofia"))),
      ));
    }
    return list;
  }
}
