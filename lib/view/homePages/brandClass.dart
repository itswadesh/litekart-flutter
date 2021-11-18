
import 'package:anne/response_handler/brandResponse.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/utility/theme.dart';
import 'package:anne/view_model/brand_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../values/route_path.dart' as routes;

class BrandClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BrandClass();
  }
}

class _BrandClass extends State<BrandClass> {
  QueryMutation addMutation = QueryMutation();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getBrandsList();
  }

  Widget getBrandsList() {
    return Consumer<BrandViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        if (value.status == "loading") {
          Provider.of<BrandViewModel>(context, listen: false).fetchBrandData();
          return Container();
        } else if (value.status == "empty") {
          return SizedBox.shrink();
        } else if (value.status == "error") {
          return SizedBox.shrink();
        } else {
          return Column(
            children: [
              Container(
                color:Color(0xffffffff),
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                height: ScreenUtil().setWidth(25),
                color: Color(0xfff3f3f3),),
              Container(
                color:Color(0xffffffff),
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                color:Color(0xffffffff),
                width: double.infinity,
                // padding: EdgeInsets.only(
                //   bottom: ScreenUtil().setWidth(
                //       7.5), // This can be the space you need betweeb text and underline
                // ),
                // decoration: BoxDecoration(
                //     border: Border(
                //         bottom: BorderSide(
                //   color: Color(0xff32AFC8),
                //   width: 2.0, // This would be the width of the underline
                // ))),
                child: Text(
                  "TOP BRANDS FOR YOU",
                  style: ThemeApp()
                      .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
                ),
              ),
              Container(
                color: Color(0xffffffff),
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                color: Color(0xffffffff),
                //  color: Colors.white,
                height: ScreenUtil().setWidth(61),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(25), 0, ScreenUtil().setWidth(25), 0),
                child: ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount: value.brandResponse!.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext build, index) {
                      BrandData data = value.brandResponse!.data![index];
                      return Container(
                        color: Color(0xffffffff),
                        //  color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            locator<NavigationService>().pushNamed(
                                routes.BrandPage,
                                args: {"brandData": data});
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(15)),
                            width: ScreenUtil().setWidth(103),
                            height: ScreenUtil().setWidth(61),
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              image: new DecorationImage(
                                fit: BoxFit.contain,
                                image: data.img != null
                                    ? NetworkImage(data.img!)
                                    : NetworkImage(
                                    'https://anne.biz/icon.png'),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                color: Color(0xffffffff),
                height: ScreenUtil().setWidth(30),
              )
            ],
          );
        }
      },
    );
  }
}