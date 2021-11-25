import 'package:anne/components/widgets/productCard.dart';
import 'package:anne/service/event/tracking.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/utility/theme.dart';
import 'package:anne/values/event_constant.dart';
import 'package:anne/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class YouMayLikeClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _YouMayLikeClass();
  }
}

class _YouMayLikeClass extends State<YouMayLikeClass> {
  QueryMutation addMutation = QueryMutation();

  // ProductResponse productResponse;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          child: getProductList(),
        )
      ],
    );
  }

  Widget getProductList() {
    return Consumer<ProductViewModel>(
        builder: (BuildContext context, value, Widget? child) {
          if (value.youMayLikeStatus == "loading") {
            Provider.of<ProductViewModel>(context, listen: false)
                .fetchYouMayLikeData();
            return Container();
          } else if (value.youMayLikeStatus == "empty") {


            return SizedBox.shrink();
          } else if (value.youMayLikeStatus == "error") {

            return SizedBox.shrink();
          }
          return Column(children: [
            Container(
              height: ScreenUtil().setWidth(15),
            ),
            Container(
              height: ScreenUtil().setWidth(25),
              color: Color(0xfff3f3f3),),
            Container(
              height: ScreenUtil().setWidth(15),
            ),
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
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
                "PRODUCTS YOU MAY LIKE",
                style: ThemeApp()
                    .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
              ),
            ),
            Container(
              color: Color(0xffffffff),
              height: ScreenUtil().setWidth(15),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(0), 0, ScreenUtil().setWidth(0), 0),
              height: ScreenUtil().setWidth(303),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: value.productYouMayLikeResponse!.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onTap: () {
                        Map<String, dynamic> data = {
                          "id": EVENT_YOU_MAY_LIKE,
                          "itemId":
                          value.productYouMayLikeResponse!.data![index].barcode,
                          "event": "tap"
                        };
                        Tracking(event: EVENT_YOU_MAY_LIKE, data: data);
                      },
                      child: Column(children: [
                        ProductCard(
                            value.productYouMayLikeResponse!.data![index])
                      ]),
                    );
                  }),
            )
          ]);
        });
  }
}