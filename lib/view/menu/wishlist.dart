import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:anne/components/widgets/cartEmptyMessage.dart';
import 'package:anne/components/widgets/errorMessage.dart';
import 'package:anne/components/widgets/loading.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/graphQl.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/view_model/cart_view_model.dart';
import 'package:anne/view_model/wishlist_view_model.dart';

import 'package:anne/view/cart_logo.dart';
import 'package:anne/view/product_detail.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
        title: Center(
            // width: MediaQuery.of(context).size.width * 0.39,
            child: Text(
          "Wishlist",
          style: TextStyle(
              color: Color(0xff616161),
              fontSize: ScreenUtil().setSp(
                21,
              )),
          textAlign: TextAlign.center,
        )),
        actions: [
          Container(
              padding: EdgeInsets.only(right: 10.0),
              // width: MediaQuery.of(context).size.width * 0.35,
              child: CartLogo())
        ],
      ),
      body: GraphQLProvider(
        client: graphQLConfiguration.initailizeClient(),
        child: CacheProvider(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color(0xfff3f3f3),
            child: getWishList(),
          ),
        ),
      ),
    );
  }

  getWishList() {
    return Consumer<WishlistViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.status == "loading") {
        Provider.of<WishlistViewModel>(context, listen: false).fetchData();
        return Loading();
      } else if (value.status == "empty") {
        return cartEmptyMessage("wishlist", "Wishlist is Empty");
      } else if (value.status == "error") {
        return errorMessage();
      }

      return SingleChildScrollView(
          child: Column(children: [
        Container(
            child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setWidth(18),
            ),
            Container(child: WishCard()),
            SizedBox(
              height: ScreenUtil().setWidth(30),
            ),
          ],
        ))
      ]));
    });
  }
}

class WishCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WishCard();
  }
}

class _WishCard extends State<WishCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // ignore: missing_required_param
    return Consumer<WishlistViewModel>(
      builder: (BuildContext context, value, Widget child) {
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: value.wishlistResponse.data.length,
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDetail(
                          value.wishlistResponse.data[index].product.id)));
                },
                child: Material(
                    color: Color(0xfff3f3f3),
                    // borderRadius: BorderRadius.circular(2),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(11), 0,
                          ScreenUtil().setWidth(15), ScreenUtil().setWidth(10)),
                      elevation: 0,
                      child: Container(
                        height: ScreenUtil().setWidth(126),
                        width: ScreenUtil().setWidth(388),
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(15),
                            ScreenUtil().setWidth(12),
                            ScreenUtil().setWidth(15),
                            ScreenUtil().setWidth(8)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          children: <Widget>[
                            new ClipRRect(
                                child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loading.gif',
                              image: value.wishlistResponse.data[index].product
                                      .img ??
                                  "https://next.anne.com/icon.png",
                              fit: BoxFit.contain,
                              width: ScreenUtil().setWidth(92),
                              height: ScreenUtil().setWidth(102),
                            )),
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(20)),
                            ),
                            Container(
                                child: Expanded(
                              child: Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: ScreenUtil().setWidth(188),
                                      child: Text(
                                        value.wishlistResponse.data[index]
                                            .product.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff616161),
                                          fontSize: ScreenUtil().setSp(
                                            17,
                                          ),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        width: ScreenUtil().setWidth(27),
                                        height: ScreenUtil().setWidth(27),
                                        decoration: new BoxDecoration(
                                            color: Color(0xffF5f5f5),
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().radius(4))),
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<CartViewModel>(context,
                                                    listen: false)
                                                .cartAddItem(
                                                    value.wishlistResponse
                                                        .data[index].product.id,
                                                    value.wishlistResponse
                                                        .data[index].product.id,
                                                    1,
                                                    false);
                                          },
                                          child: Icon(
                                            Icons.add_shopping_cart,
                                            color: Color(0xffbb8728),
                                            size: ScreenUtil().setWidth(15),
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(2),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    value.wishlistResponse.data[index].product
                                        .brand,
                                    style: TextStyle(
                                      color: Color(0xffba8638),
                                      fontSize: ScreenUtil().setWidth(13),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(11),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "₹ " +
                                        value.wishlistResponse.data[index]
                                            .product.price
                                            .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff00ba0e),
                                        fontSize: ScreenUtil().setSp(
                                          14,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(10),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        InkWell(
                                            onTap: () {
                                              Provider.of<WishlistViewModel>(
                                                      context,
                                                      listen: false)
                                                  .toggleItem(value
                                                      .wishlistResponse
                                                      .data[index]
                                                      .product
                                                      .id);
                                            },
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                width:
                                                    ScreenUtil().setWidth(27),
                                                height:
                                                    ScreenUtil().setWidth(27),
                                                decoration: new BoxDecoration(
                                                    color: Color(0xfff5f5f5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil()
                                                                .radius(4))),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Color(0xff656565),
                                                  size:
                                                      ScreenUtil().setWidth(18),
                                                )))
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                            ))
                          ],
                        ),
                      ),
                    )),
              );
            });
      },
    );
  }
}
