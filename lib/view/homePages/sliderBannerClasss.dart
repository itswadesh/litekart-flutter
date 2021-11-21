import 'package:anne/service/event/tracking.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/api_endpoint.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/values/event_constant.dart';
import 'package:anne/view_model/banner_view_model.dart';
import 'package:anne/view_model/brand_view_model.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../values/route_path.dart' as routes;
import '../product_list.dart';

class BannersSliderClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BannersSliderClass();
  }
}

class _BannersSliderClass extends State<BannersSliderClass> {
  QueryMutation addMutation = QueryMutation();
  final List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [

        Container(child: getBannersList())
      ],
    );
  }

  Widget getBannersList() {
    return Consumer<BannerViewModel>(
        builder: (BuildContext context, BannerViewModel value, Widget? child) {
          if (value.statusSlider == "loading") {
            Provider.of<BannerViewModel>(context, listen: false).fetchSliderData();
            return Container();
          } else if (value.statusSlider == "empty") {
            return Container();
          } else if (value.statusSlider == "error") {
            return Container();
          } else {

            return value.sliderResponse!.data!.length>0? Container(
              child: CarouselSlider.builder(
                itemCount: value.sliderResponse!.data!.length,
                options: CarouselOptions(
                  viewportFraction: 1,
                  aspectRatio: 18 / 10,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
                itemBuilder: (ctx, index, _index) {
                  if (value.sliderResponse?.data![index] != null) {
                    return InkWell(
                      onTap: () async {
                        Map<String, dynamic> data = {
                          "id": EVENT_HOME_MAIN_SLIDER,
                          "imageUrl":
                          value.sliderResponse?.data![index].img.toString(),
                          "position": index,
                          "event": "tap",
                        };
                        Tracking(event: EVENT_HOME_MAIN_SLIDER, data: data);


                        if (value.sliderResponse!.data![index].link == null ||
                            value.sliderResponse!.data![index].link == "") {

                        }
                        else if(value.sliderResponse!.data![index].link!.contains(ApiEndpoint().brandLink!)){

                          for(int i=0; i<Provider.of<BrandViewModel>(context,listen: false).brandResponse!.data!.length;i++)
                          {

                            if(Provider.of<BrandViewModel>(context,listen: false).brandResponse!.data![i].name!.toLowerCase()==value.sliderResponse!.data![index].link!.split(ApiEndpoint().brandLink!)[1]){

                              locator<NavigationService>().pushNamed(routes.BrandPage,args: {"brandData":Provider.of<BrandViewModel>(context,listen: false).brandResponse!.data![i]});
                            }
                          }
                        }
                        else{
                          locator<NavigationService>().push(MaterialPageRoute(
                              builder: (context) => ProductList("", "", "", "", "",
                                  value.sliderResponse!.data![index].link)));
                        }

                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().radius(0))),
                          child: Container(
                            width: ScreenUtil().setWidth(414),
                            height:  ScreenUtil().setWidth(4140/18),
                            child:
                            // CachedNetworkImage(
                            //     width: ScreenUtil().setWidth(414),
                            //     height:  ScreenUtil().setWidth(4140/18),
                            //     fit: BoxFit.cover,
                            //   imageUrl: value.sliderResponse?.data![index].img.toString()??""+"?tr=w-414,fo-auto",
                            //   imageBuilder: (context, imageProvider) => Container(
                            //     decoration: BoxDecoration(
                            //       image: DecorationImage(
                            //         onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",    width: ScreenUtil().setWidth(414),
                            //           height:  ScreenUtil().setWidth(4140/18),
                            //           fit: BoxFit.cover,),
                            //         image: imageProvider,
                            //       ),
                            //     ),
                            //   ),
                            //   // placeholder: (context, url) => Image.asset("assets/images/loading.gif",    width: ScreenUtil().setWidth(414),
                            //   //   height:  ScreenUtil().setWidth(4140/18),
                            //   //   fit: BoxFit.cover,
                            //   // ),
                            //   errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",    width: ScreenUtil().setWidth(414),
                            //     height:  ScreenUtil().setWidth(4140/18),
                            //     fit: BoxFit.cover,),
                            // ),
                            Image.network(
                              value.sliderResponse!.data![index].img!.toString(),
                              errorBuilder: (context,object,stackTrace){
                                return Image.asset("assets/images/logo.png", width: ScreenUtil().setWidth(414),
                                  height:  ScreenUtil().setWidth(4140/18),
                                  fit: BoxFit.cover,);
                              },
                              width: ScreenUtil().setWidth(414),
                              height:  ScreenUtil().setWidth(4140/18),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ):Container();
          }
        });
  }
}