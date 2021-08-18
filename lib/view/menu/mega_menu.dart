import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
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
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil().setWidth(19),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(23)),
                height: ScreenUtil().setWidth(55),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: value.topMegaMenuResponse.megamenu.length,
                    itemBuilder: (buildContext, index) {
                      return GestureDetector(
                          onTap: () {
                            Provider.of<MegaMenuViewModel>(context,
                                    listen: false)
                                .selectTopIndex(index);
                          },
                          child: topMenuCard(
                              value.topMegaMenuResponse.megamenu[index],
                              index == value.selectedTopIndex));
                    }),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(19),
              ),
              getMenuCard(value.topMegaMenuResponse
                  .megamenu[value.selectedTopIndex].children)
            ],
          ),
        );
      }
    });
  }

  topMenuCard(MegaMenuResponse megamenu, bool colorStatus) {
    return Container(
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().radius(10))),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: colorStatus ? Color(0xffEAA13B) : Color(0xff)),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(10))),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(28),
                ScreenUtil().setWidth(15),
                ScreenUtil().setWidth(28),
                ScreenUtil().setWidth(15)),
            child: Center(
              child: Text(
                megamenu.name,
                style: TextStyle(
                    color: colorStatus ? Color(0xffEAA13B) : Color(0xff6d6d6d),
                    fontSize: ScreenUtil().setSp(15),
                    fontFamily: "Sofia"),
              ),
            )),
      ),
    );
  }

  getMenuCard(List<MegaMenuChildren1> children) {
    return Container(
      child: ListView.builder(
          itemCount: children.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (buildContext, index) {
            return Card(
              margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(23), 0,
                  ScreenUtil().setWidth(23), ScreenUtil().setWidth(23)),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(10))),
              child: ExpansionTile(
                  title: Text(
                    children[index].name,
                    style: TextStyle(
                        color: Color(0xffEAA13B),
                        fontSize: ScreenUtil().setSp(15),
                        fontFamily: "Sofia"),
                  ),
                  children: getExpansionTileChild(children[index].children)),
            );
          }),
    );
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
                "parentBrand":""
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
