import 'dart:developer';

import 'package:anne/response_handler/bannerResponse.dart';

import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/api_endpoint.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/utility/theme.dart';

import 'package:anne/view_model/banner_view_model.dart';
import 'package:anne/view_model/brand_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../values/route_path.dart' as routes;
import '../product_list.dart';

class PickedBannersClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PickedBannersClass();
  }
}

class _PickedBannersClass extends State<PickedBannersClass> {
  QueryMutation addMutation = QueryMutation();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [Container(child: getBannersList())],
    );
  }

  Widget getBannersList() {
    return Consumer<BannerViewModel>(
        builder: (BuildContext context, value, Widget? child) {
          if (value.statusPickedBanner == "loading") {
            Provider.of<BannerViewModel>(context, listen: false).fetchPickedBannerData();
            return Container();
          } else if (value.statusPickedBanner == "empty") {
            return SizedBox.shrink();
          } else if (value.statusPickedBanner == "error") {
            return SizedBox.shrink();
          } else {
            return Column(children: getColumn(value.pickedBannerResponse!));
          }
        });
  }

  getColumn(BannerResponse bannerResponse) {
    List<Widget> children = [];
    for (int i = 0; i < bannerResponse.groupByBanner!.length; i++) {
      log(bannerResponse.groupByBanner![i].title!);
      children.add( Container(
        color:Color(0xffffffff),
        height: ScreenUtil().setWidth(15),
      ));
      children.add( Container(
        height: ScreenUtil().setWidth(25),
        color: Color(0xfff3f3f3),));
      children.add( Container(
        color:Color(0xffffffff),
        height: ScreenUtil().setWidth(15),
      ));
      children.add( Container(
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
          bannerResponse.groupByBanner![i].title!,
          style: ThemeApp()
              .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
        ),
      ));
      children.add( Container(
        color: Color(0xffffffff),
        height: ScreenUtil().setWidth(15),
      ));
      children.add(Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        height: ScreenUtil().setWidth(220),
        child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            scrollDirection: Axis.horizontal,
            itemCount: bannerResponse.groupByBanner![i].data!.length,
            itemBuilder: (BuildContext context, index) {
              return InkWell(
                onTap: () {},
                child: Column(children: [
                  InkWell(
                    onTap: () async {
                      // Map<String, dynamic> data = {
                      //   "id": EVENT_HOME_PROMO_BANNER,
                      //   "position": index,
                      //   "event": "tap"
                      // };
                      // Tracking(event: EVENT_HOME_PROMO_BANNER, data: data);


                      if (bannerResponse.groupByBanner![i].data![index].link == null ||
                          bannerResponse.groupByBanner![i].data![index].link == "") {

                      }
                      else if(bannerResponse.groupByBanner![i].data![index].link!.contains(ApiEndpoint().brandLink!)){

                        for(int i=0; i<Provider.of<BrandViewModel>(context,listen: false).brandResponse!.data!.length;i++)
                        {

                          if(Provider.of<BrandViewModel>(context,listen: false).brandResponse!.data![i].name!.toLowerCase()==bannerResponse.groupByBanner![i].data![index].link!.split(ApiEndpoint().brandLink!)[1]){
                            locator<NavigationService>().pushNamed(routes.BrandPage,args: {"brandData":Provider.of<BrandViewModel>(context,listen: false).brandResponse!.data![i]});
                          }
                        }
                      }
                      else{
                        locator<NavigationService>().push(MaterialPageRoute(
                            builder: (context) => ProductList("", "", "", "", "",
                                bannerResponse.groupByBanner![i].data![index].link)));
                      }
                    },
                    child:  Container(
                      height: ScreenUtil().setWidth(220),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: FadeInImage.assetNetwork(
                        imageErrorBuilder: ((context,object,stackTrace){
                          return Image.asset("assets/images/logo.png");
                        }),
                        placeholder: 'assets/images/loading.gif',
                        image: bannerResponse
                            .groupByBanner![i].data![index].img!+"?tr=h-220,fo-auto",
                      ),
                      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), 0, 0, 0),
                    ),
                  ),
                ]),
              );
            }),
      ));
    }
    return children;
  }
}