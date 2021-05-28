import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anne/model/product.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/values/route_path.dart' as routes;
class ProductViewColorCard extends StatelessWidget {
  final ProductData productData;

  ProductViewColorCard(this.productData);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        onTap: () async{
         await locator<NavigationService>().pushNamed(routes.ProductDetailRoute,args: productData.id);
        },
        child: Card(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(19)),
          child: Container(
            width: ScreenUtil().setWidth(197),
            height: ScreenUtil().setWidth(248),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(34),
                      ScreenUtil().setWidth(18),
                      ScreenUtil().setWidth(34),
                      ScreenUtil().setWidth(14)),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: productData.img,
                    height: ScreenUtil().setWidth(131),
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(197),
                  height: ScreenUtil().setWidth(91),
                  decoration: BoxDecoration(
                      color: Color(0xffCCFFE7),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(ScreenUtil().radius(5)),
                          bottomRight:
                              Radius.circular(ScreenUtil().radius(5)))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setWidth(15),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(7),
                              0, ScreenUtil().setWidth(7), 0),
                          child: Text(productData.name,
                              style: TextStyle(
                                  color: Color(0xff4A4A4A),
                                  fontSize: ScreenUtil().setSp(
                                    15,
                                  )),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                      SizedBox(
                        height: ScreenUtil().setWidth(5),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(7),
                              0, ScreenUtil().setWidth(7), 0),
                          child: Text(
                            productData.brand == null
                                ? ""
                                : (productData.brand.name ?? ""),
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                13,
                              ),
                              color: Color(0xff919191),
                            ),
                          )),
                      SizedBox(
                        height: ScreenUtil().setWidth(9),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(7),
                              0,
                              ScreenUtil().setWidth(7),
                              ScreenUtil().setWidth(5)),
                          child: Text(
                            "₹ " + productData.price.toString() + " ",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(
                                  18,
                                ),
                                color: Color(0xff009B52),
                                fontWeight: FontWeight.w600),
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
