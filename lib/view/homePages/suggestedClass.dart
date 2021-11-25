import 'package:anne/components/widgets/productCard.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/utility/theme.dart';
import 'package:anne/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class SuggestedClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SuggestedClass();
  }
}

class _SuggestedClass extends State<SuggestedClass> {
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
          if (value.suggestedStatus == "loading") {
            Provider.of<ProductViewModel>(context, listen: false)
                .fetchSuggestedData();
            return Container();
          } else if (value.suggestedStatus == "empty") {
            return SizedBox.shrink();
          } else if (value.suggestedStatus == "error") {
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
                "SUGGESTED PRODUCTS FOR YOU",
                style: ThemeApp()
                    .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
              ),
            ),
            Container(
              height: ScreenUtil().setWidth(15),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  0, 0, 0, 0),
              height: ScreenUtil().setWidth(289),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: value.productSuggestedResponse!.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return Column(
                      children: [
                        ProductCard(
                            value.productSuggestedResponse!.data![index])
                      ],
                    );
                  }),
            )
          ]);
        });
  }
}