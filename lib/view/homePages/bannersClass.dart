import 'package:anne/response_handler/bannerResponse.dart';
import 'package:anne/service/event/tracking.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/api_endpoint.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/values/event_constant.dart';
import 'package:anne/view_model/banner_view_model.dart';
import 'package:anne/view_model/brand_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../values/route_path.dart' as routes;
import '../product_list.dart';

class BannersClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BannersClass();
  }
}

class _BannersClass extends State<BannersClass> {
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
          if (value.statusBanner == "loading") {
            Provider.of<BannerViewModel>(context, listen: false).fetchBannerData();
            return Container();
          } else if (value.statusBanner == "empty") {
            return SizedBox.shrink();
          } else if (value.statusBanner == "error") {
            return SizedBox.shrink();
          } else {
            return Column(children: getColumn(value.bannerResponse!));
          }
        });
  }

  getColumn(BannerResponse bannerResponse) {
    List<Widget> children = [];
    for (int i = 0; i < bannerResponse.groupByBanner!.length; i++) {
      children.add(
        SizedBox(
          height: 10,
        ),
      );
      children.add(InkWell(
          onTap: () async {

            if (bannerResponse.groupByBanner![i].data![0].link == null ||
                bannerResponse.groupByBanner![i].data![0].link == "") {

            }
            else if(bannerResponse.groupByBanner![i].data![0].link!.contains(ApiEndpoint().brandLink!)){
              for(int i=0; i<Provider.of<BrandViewModel>(context,listen: false).brandResponse!.data!.length;i++)
              {
                if(Provider.of<BrandViewModel>(context,listen: false).brandResponse!.data![i].name!.toLowerCase()==bannerResponse.groupByBanner![i].data![0].link!.split(ApiEndpoint().brandLink!)[1]){
                  locator<NavigationService>().pushNamed(routes.BrandPage,args: {"brandData":Provider.of<BrandViewModel>(context,listen: false).brandResponse!.data![i]});
                }
              }
            }
            else{
              locator<NavigationService>().push(MaterialPageRoute(
                  builder: (context) => ProductList("", "", "", "", "",
                      bannerResponse.groupByBanner![i].data![0].link)));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child:
            CachedNetworkImage(
              imageUrl: bannerResponse.groupByBanner![i].data![0].img!+"?tr=w-414,fo-auto",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",),
                    image: imageProvider,
                  ),
                ),
              ),
              placeholder: (context, url) => Image.asset("assets/images/loading.gif",
                ),
              errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",),
            ),
      //       FadeInImage.assetNetwork(
			// imageErrorBuilder: ((context,object,stackTrace){
      //                       return Image.asset("assets/images/logo.png");
      //                     }),
      //           placeholder: 'assets/images/loading.gif',
      //           image: bannerResponse.groupByBanner![i].data![0].img!+"?tr=w-414,fo-auto"),
          )));
      children.add(
        SizedBox(
          height: 10,
        ),
      );
if(bannerResponse.groupByBanner![i].data!.length>1){
      children.add(Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        height: 185,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bannerResponse.groupByBanner![i].data!.length,
            itemBuilder: (BuildContext context, index) {
              if (bannerResponse.groupByBanner![0].data != null) {
                return InkWell(
                  onTap: () {},
                  child: Column(children: [
                    InkWell(
                      onTap: () async {
                        Map<String, dynamic> data = {
                          "id": EVENT_HOME_PROMO_BANNER,
                          "position": index,
                          "event": "tap"
                        };
                        Tracking(event: EVENT_HOME_PROMO_BANNER, data: data);


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
                      child: index == 0
                          ? Container()
                          : Container(
                        height: 160,
                        child:
                        // CachedNetworkImage(
                        //   imageUrl: bannerResponse
                        //           .groupByBanner![i].data![index].img!+"?tr=h-160,fo-auto",
                        //   imageBuilder: (context, imageProvider) => Container(
                        //     decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //         onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",),
                        //         image: imageProvider,
                        //       ),
                        //     ),
                        //   ),
                        //   placeholder: (context, url) => Image.asset("assets/images/loading.gif",
                        //   ),
                        //   errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",),
                        // ),
                        FadeInImage.assetNetwork(
                          imageErrorBuilder: ((context,object,stackTrace){
                            return Image.asset("assets/images/logo.png");
                          }),
                          placeholder: 'assets/images/loading.gif',
                          image: bannerResponse
                              .groupByBanner![i].data![index].img!+"?tr=h-160,fo-auto",
                        ),
                        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), 10, 0, 0),
                      ),
                    ),
                  ]),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
      ));
}
    }
    return children;
  }
}
