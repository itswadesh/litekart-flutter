import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anne/model/product.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/view/product_detail.dart';
import 'package:anne/values/route_path.dart' as routes;
class ProductViewColor3Card extends StatelessWidget {
  final ProductData productData;

  ProductViewColor3Card(this.productData);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        onTap: () async{
         await locator<NavigationService>().pushNamed(routes.ProductDetailRoute,args: productData.id);
        },
        child: Card(
          margin: EdgeInsets.only(left: 21),
          child: Container(
            width: ScreenUtil().setWidth(203),
            height: ScreenUtil().setWidth(255),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    productData.hot == true
                        ? Column(
                            children: [
                              Container(
                                  height: ScreenUtil().setWidth(18),
                                  width: ScreenUtil().setWidth(80),
                                  color: Color(0xffFF2300),
                                  child: Center(
                                    child: Text(
                                      "Hot Deals",
                                      style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontSize: ScreenUtil().setSp(
                                            9,
                                          )),
                                    ),
                                  )),
                              SizedBox(
                                height: ScreenUtil().setWidth(15),
                              )
                            ],
                          )
                        : Container(
                            height: ScreenUtil().setWidth(33),
                          ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(9),
                          ScreenUtil().setWidth(8), 0),
                      width: ScreenUtil().radius(24),
                      height: ScreenUtil().radius(24),
                      decoration: new BoxDecoration(
                        color: Color(0xffFFE8E8),
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xffff2300),
                                width: ScreenUtil().setWidth(0.4)),
                            top: BorderSide(
                                color: Color(0xffff2300),
                                width: ScreenUtil().setWidth(0.4)),
                            left: BorderSide(
                                color: Color(0xffff2300),
                                width: ScreenUtil().setWidth(0.4)),
                            right: BorderSide(
                                color: Color(0xffff2300),
                                width: ScreenUtil().setWidth(0.4))),
                        shape: BoxShape.circle,
                      ),
                      child: CheckWishListClass(productData.id, productData.id),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(25), 0,
                      ScreenUtil().setWidth(25), 12),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: productData.img,
                    height: ScreenUtil().setWidth(121),
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(203),
                  height: ScreenUtil().setWidth(87),
                  decoration: BoxDecoration(
                      color: Color(0xffFFE0DB),
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
                          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(7),
                              0, ScreenUtil().setWidth(7), 0),
                          child: Text(
                            "₹ " + productData.price.toString() + " ",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(
                                  18,
                                ),
                                color: Color(0xffFF461B),
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
