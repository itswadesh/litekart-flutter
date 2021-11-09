import 'package:anne/components/widgets/loading.dart';
import 'package:anne/service/event/tracking.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/values/event_constant.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/view_model/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../values/route_path.dart' as routes;


class CategoriesClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CategoriesClass();
  }
}

class _CategoriesClass extends State<CategoriesClass> {
  QueryMutation addMutation = QueryMutation();

  // CategoriesResponse categoryResponse;

  @override
  Widget build(BuildContext context) {
    // ApiResponse apiResponse = Provider.of<CategoryViewModel>(context).response;
    // categoryResponse = apiResponse.data as CategoriesResponse;
    // TODO: implement build
    return Column(
      children: [
        Container(
          // This can be the space you need between text and underline
          padding: EdgeInsets.only(bottom: 3, top: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: Color(0xff32AFC8),
                    width: ScreenUtil()
                        .setWidth(3), // This would be the width of the underline
                  ))),
          child: Text(
            "Categories",
            style: TextStyle(
                color: Color(0xff32AFC8),
                fontWeight: FontWeight.w500,
                fontSize: 18.0),
            // style: ThemeApp().underlineThemeText(Color(0xff32AFC8), 18.0, true),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(30),
        ),
        getCategoriesList()
      ],
    );
  }

  Widget getCategoriesList() {
    return Consumer<CategoryViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        if (value.status == "loading") {
          Provider.of<CategoryViewModel>(context, listen: false)
              .fetchCategoryData();
          if (Provider.of<ProfileModel>(context).user == null) {
            Provider.of<ProfileModel>(context, listen: false).getProfile();
          }
          return Loading();
        } else if (value.status == "empty") {
          return SizedBox.shrink();
        } else if (value.status == "error") {
          return SizedBox.shrink();
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), 0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 2.6),
                    crossAxisCount: 2),
                itemCount: value.categoryResponse!.data!.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext build, index) {
                  return Container(
                      child: InkWell(
                          onTap: () {},
                          child: InkWell(
                            onTap: () {
                              Map<String, dynamic> data = {
                                "id": EVENT_HOME_CATEGORIES,
                                "title":
                                value.categoryResponse!.data![index].name,
                                "url": value.categoryResponse!.data![index].slug,
                                "event": "tap"
                              };
                              Tracking(
                                  event: EVENT_HOME_CATEGORIES, data: data);
                              locator<NavigationService>()
                                  .pushNamed(routes.ProductList, args: {
                                "searchKey": "",
                                "category":
                                value.categoryResponse!.data![index].slug,
                                "brandName": "",
                                "parentBrand": ""
                              });
                            },
                            child: Column(
                              children: [
                                Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(
                                                ScreenUtil().radius(40)),
                                            topRight: Radius.circular(
                                                ScreenUtil().radius(40)),
                                            bottomLeft: Radius.circular(
                                                ScreenUtil().radius(40)),
                                            topLeft: Radius.circular(
                                                ScreenUtil().radius(40)))),
                                    child: Container(
                                        width: ScreenUtil().radius(95),
                                        height: ScreenUtil().radius(95),
                                        decoration: new BoxDecoration(
                                            border: Border(
                                                bottom:
                                                BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(1)),
                                                top: BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(1)),
                                                left: BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(1)),
                                                right: BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(1))),
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(fit: BoxFit.cover, image: new NetworkImage(value.categoryResponse!.data![index].img ?? 'https://next.anne.com/icon.png'))))),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  value.categoryResponse!.data![index].name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        14,
                                      ),
                                      color: Color(0xff616161)),
                                ),
                              ],
                            ),
                          )));
                }),
          );
        }
      },
    );
  }
}