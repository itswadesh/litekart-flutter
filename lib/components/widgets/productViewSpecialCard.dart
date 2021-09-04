import 'dart:math';

import 'package:anne/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/product.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../values/route_path.dart' as routes;

class ProductViewSpecialCard extends StatelessWidget {
  final ProductData productData;

  ProductViewSpecialCard(this.productData);

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
      child: Container(
          width: ScreenUtil().setWidth(236),
          height: ScreenUtil().setWidth(187),
          child: Stack(children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: gradientColors[
                              Random().nextInt(gradientColors.length)],
                          width: ScreenUtil().setWidth(8)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          gradientColors[
                              Random().nextInt(gradientColors.length)],
                          gradientColors[
                              Random().nextInt(gradientColors.length)],
                          gradientColors[
                              Random().nextInt(gradientColors.length)]
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().radius(10)),
                          topRight: Radius.circular(ScreenUtil().radius(10)),
                          bottomLeft: Radius.circular(ScreenUtil().radius(10)),
                          bottomRight:
                              Radius.circular(ScreenUtil().radius(10)))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setWidth(23),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(17),
                              0,
                              ScreenUtil().setWidth(17),
                              0),
                          child: Text(productData.name,
                              style: TextStyle(
                                  color: Color(0xff4A4A4A),
                                  fontSize: ScreenUtil().setSp(
                                    18,
                                  )),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                      SizedBox(
                        height: ScreenUtil().setWidth(7),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(17),
                              0,
                              ScreenUtil().setWidth(17),
                              0),
                          child: Text(
                            productData.brand == null
                                ? ""
                                : (productData.brand.name ?? ""),
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                14,
                              ),
                              color: Color(0xff919191),
                            ),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        height: ScreenUtil().setWidth(36),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(17),
                              0,
                              ScreenUtil().setWidth(17),
                              0),
                          child: Text(
                            productData.stock.toString() + " Item left*",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                12,
                              ),
                              color: Color(0xffFF2300),
                            ),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(height: ScreenUtil().setWidth(26)),
                      Container(
                        padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(17),
                            0, ScreenUtil().setWidth(7), 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "₹ " + productData.price.toString() + "  ",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    21,
                                  ),
                                  color: AppColors.primaryElement2,
                                ),
                              ),
                              productData.price < productData.mrp
                                  ? Text(
                                      " ₹ " + productData.mrp.toString(),
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: ScreenUtil().setSp(
                                            13,
                                          ),
                                          color: Color(0xff919191)),
                                    )
                                  : Container(),
                            ]),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(10),
                      )
                    ],
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Transform.translate(
                offset: Offset(ScreenUtil().setWidth(8), 0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loading.gif',
                  image: productData.img,
                  width: ScreenUtil().setWidth(70),
                  height: ScreenUtil().setWidth(125),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ])),
    );
  }
}
