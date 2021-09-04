import 'package:anne/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../response_handler/productListApiReponse.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../utility/query_mutation.dart';
import '../../view_model/cart_view_model.dart';
import '../../view/product_detail.dart';
import '../../values/route_path.dart' as routes;

class ProductViewCard extends StatefulWidget {
  final productData;

  ProductViewCard(this.productData);

  @override
  _ProductViewCardState createState() => _ProductViewCardState();
}

class _ProductViewCardState extends State<ProductViewCard> {
  List<String> images;
  ProductListData productData;

  @override
  void initState() {
    productData = ProductListData.fromJson(widget.productData);
    if (productData != null &&
        productData.images != null &&
        productData.images is List) {
      images = List.from(productData.images?.map((x) => x));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: InkWell(
        onTap: () async {
          await locator<NavigationService>()
              .pushNamed(routes.ProductDetailRoute, args: productData.id);
        },
        child: Card(
          child: Container(
            width: ScreenUtil().setWidth(183),
            //     height: ScreenUtil().setWidth(269),
            height: ScreenUtil().setWidth(228),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(
                              0,
                              ScreenUtil().setWidth(7),
                              ScreenUtil().setWidth(10),
                              0),
                          width: ScreenUtil().radius(26),
                          height: ScreenUtil().radius(26),
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
                          child: CheckWishListClass(
                              productData.id, productData.id))
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(3),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(36), 0,
                      ScreenUtil().setWidth(36), ScreenUtil().setWidth(13)),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: images.first,
                    height: ScreenUtil().setWidth(110),
                    width: ScreenUtil().setWidth(111),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
                        ScreenUtil().setWidth(20), 0),
                    child: Text(
                      productData.brand,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          9,
                        ),
                        color: AppColors.primaryElement,
                      ),
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                  height: ScreenUtil().setWidth(9),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
                        ScreenUtil().setWidth(20), 0),
                    child: Text(productData.name,
                        style: TextStyle(
                            color: Color(0xff5f5f5f),
                            fontSize: ScreenUtil().setSp(
                              13,
                            )),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1)),
                SizedBox(
                  height: ScreenUtil().setWidth(7),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹ " + productData.price.toString() + " ",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            14,
                          ),
                          color: Color(0xff4a4a4a)),
                    ),
                    productData.price < productData.mrp
                        ? Text(
                            " ₹ " + productData.mrp.toString(),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: ScreenUtil().setSp(
                                  9,
                                ),
                                color: Color(0xff4a4a4a)),
                          )
                        : Container(),
                    productData.price < productData.mrp
                        ? Text(
                            " (${(100 - ((productData.price / productData.mrp) * 100)).toInt()} % off)",
                            style: TextStyle(
                                color: AppColors.primaryElement2,
                                fontSize: ScreenUtil().setSp(
                                  8,
                                )),
                          )
                        : Container()
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(15),
                ),
                // ProductAddButton(productData.id),
                // SizedBox(
                //   height: ScreenUtil().setWidth(11),
                // ),
                // Text(
                //   "Size: XS, S, M, L",
                //   style: TextStyle(
                //       color: Color(0xff434343),
                //       fontSize:
                //           ScreenUtil().setSp(11, )),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductAddButton extends StatefulWidget {
  final id;

  ProductAddButton(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductAddButton();
  }
}

class _ProductAddButton extends State<ProductAddButton> {
  QueryMutation addMutation = QueryMutation();
  var buttonValue = "+ ADD";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: ScreenUtil().setWidth(21),
      width: ScreenUtil().setWidth(57),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().radius(25)),
          ),
          textStyle: TextStyle(
              fontSize: ScreenUtil().setSp(
                13,
              ),
              color: Colors.white),
          primary: Color(0xff32afc8),
        ),
        onPressed: () async {
          if (buttonValue != "ADDED") {
            setState(() {
              buttonValue = "ADDED";
            });
          }
          Provider.of<CartViewModel>(context, listen: false)
              .cartAddItem(widget.id, widget.id, 1, false);
        },
        child: Text(
          buttonValue,
        ),
      ),
    );
  }
}
