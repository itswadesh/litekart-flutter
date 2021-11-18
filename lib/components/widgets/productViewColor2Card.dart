import 'dart:math';

import 'package:anne/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/product.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../values/route_path.dart' as routes;

class ProductViewColor2Card extends StatelessWidget {
  final ProductData productData;

  ProductViewColor2Card(this.productData);

  final List gradientColors = [
    Color(0xffCCFFE7),
    Color(0xffc5c5c5),
    Color(0xffE1FFB5),
    Color(0xff98EEFF)
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        onTap: () async {
          await locator<NavigationService>()
              .pushNamed(routes.ProductDetailRoute, args: productData.id);
        },
        child: Card(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
          child: Container(
            width: ScreenUtil().setWidth(187),
            // height: ScreenUtil().setWidth(250),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(23),
                      ScreenUtil().setWidth(12),
                      ScreenUtil().setWidth(23),
                      ScreenUtil().setWidth(18)),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: productData.img!,
                    height: ScreenUtil().setWidth(132),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          gradientColors[
                              Random().nextInt(gradientColors.length)],
                          Colors.white
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(ScreenUtil().radius(5)),
                          bottomRight:
                              Radius.circular(ScreenUtil().radius(5)))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setWidth(11),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(7),
                              0, ScreenUtil().setWidth(7), 0),
                          child: Text(
                            productData.brand == null
                                ? ""
                                : (productData.brand!.name ?? ""),
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                13,
                              ),
                              color: Color(0xff919191),
                            ),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        height: ScreenUtil().setWidth(9),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(7),
                              0, ScreenUtil().setWidth(7), 0),
                          child: Text(productData.name!,
                              style: TextStyle(
                                  color: Color(0xff4A4A4A),
                                  fontSize: ScreenUtil().setSp(
                                    15,
                                  )),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                      SizedBox(
                        height: ScreenUtil().setWidth(17),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(7),
                              0,
                              ScreenUtil().setWidth(7),
                              ScreenUtil().setWidth(7)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "₹ " +
                                          productData.price.toString() +
                                          "  ",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(
                                          14,
                                        ),
                                        color: AppColors.primaryElement2,
                                      ),
                                    ),
                                    productData.price! < productData.mrp!
                                        ? Text(
                                            " ₹ " + productData.mrp.toString(),
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: ScreenUtil().setSp(
                                                  11,
                                                ),
                                                color: Color(0xff919191)),
                                          )
                                        : Container(),
                                  ]),
                              productData.price! < productData.mrp!
                                  ? Container(
                                      height: ScreenUtil().setWidth(15),
                                      width: ScreenUtil().setWidth(36),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().radius(2)),
                                        color: Color(0xff2E2E2E),
                                      ),
                                      child: Center(
                                          child: Text(
                                        " ${(100 - (productData.price! / productData.mrp!) * 100).toInt()}% off ",
                                        style: TextStyle(
                                            color: Color(0xffffffff),
                                            fontSize: ScreenUtil().setSp(
                                              7,
                                            )),
                                      )))
                                  : Container()
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
