import 'package:anne/components/widgets/productCard.dart';
import 'package:anne/service/event/tracking.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/utility/theme.dart';
import 'package:anne/values/event_constant.dart';
import 'package:anne/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TrendingClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TrendingClass();
  }
}

class _TrendingClass extends State<TrendingClass> {
  QueryMutation addMutation = QueryMutation();

  @override
  Widget build(BuildContext context) {
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
          if (value.trendingStatus == "loading") {
            Provider.of<ProductViewModel>(context, listen: false).fetchHotData();
            return Container();
          } else if (value.trendingStatus == "empty") {
            return SizedBox.shrink();
          } else if (value.trendingStatus == "error") {
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
                "TRENDING PRODUCTS FOR YOU",
                style: ThemeApp()
                    .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
              ),
            ),
            Container(
              height: ScreenUtil().setWidth(15),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(7), 0, ScreenUtil().setWidth(7), 0),
              height: ScreenUtil().setWidth(303),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: value.productTrendingResponse!.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onTap: () {
                        Map<String, dynamic> data = {
                          "id": EVENT_TRENDING,
                          "itemId":
                          value.productTrendingResponse!.data![index].barcode,
                          "event": "tap"
                        };
                        Tracking(event: EVENT_TRENDING, data: data);
                      },
                      child: Column(children: [
                        ProductCard(
                            value.productTrendingResponse!.data![index])
                      ]),
                    );
                  }),
            )
          ]);
        });
  }
}