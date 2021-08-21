import 'dart:developer';

import 'package:anne/response_handler/wishlistResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../components/widgets/cartEmptyMessage.dart';
import '../../components/widgets/errorMessage.dart';
import '../../components/widgets/loading.dart';
import '../../utility/graphQl.dart';
import '../../view_model/cart_view_model.dart';
import '../../view_model/wishlist_view_model.dart';
import '../../view/cart_logo.dart';
import '../../view/product_detail.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Wishlist",
          style: TextStyle(
              color: Color(0xff616161),
              fontSize: ScreenUtil().setSp(
                21,
              )),
          textAlign: TextAlign.center,
        ),
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
          log("hiii there");
      if (value.status == "loading") {
          Provider.of<WishlistViewModel>(context, listen: false).fetchData();
        return Loading();
      } else if (value.status == "empty") {
        return cartEmptyMessage("wishlist", "Wishlist is Empty");
      } else if (value.status == "error") {
        return errorMessage();
      }

      return
        Container(
            child:  Consumer<WishlistViewModel>(
                builder: (BuildContext context, value, Widget child) {
              return PagedGridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio:
                        ScreenUtil().setWidth(183) / ScreenUtil().setWidth(280),
                    crossAxisCount: 2),
                pagingController: value.pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) => WishCard(item),
                    // firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
                    //   error: _pagingController.error,
                    //   onTryAgain: () => _pagingController.refresh(),
                    // ),
                    // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
                    //   error: _pagingController.error,
                    //   onTryAgain: () => _pagingController.retryLastFailedRequest(),
                    // ),
                    firstPageProgressIndicatorBuilder: (_) => Loading(),
                    newPageProgressIndicatorBuilder: (_) => Loading(),
                    noItemsFoundIndicatorBuilder: (_) =>
                        cartEmptyMessage("search", "No Product Found")),
                // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
              );
            }));
    });
  }
}

class WishCard extends StatefulWidget {
  final item;
  WishCard(this.item);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WishCard();
  }
}

class _WishCard extends State<WishCard> {
  WishlistData item;

  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // ignore: missing_required_param
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
        border: Border.all(color: Color(0xffb1b1b1))
      ),
      child: InkWell(
        onTap: () async {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProductDetail(item.id)));
        },
        child: Container(
          width: ScreenUtil().setWidth(183),
          //     height: ScreenUtil().setWidth(269),
          height: ScreenUtil().setWidth(280),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.gif',
                      image: item.product.img,
                      height: ScreenUtil().setWidth(193),
                      width: ScreenUtil().setWidth(193),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        right: ScreenUtil().setWidth(10),
                        top: ScreenUtil().setWidth(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            await Provider.of<WishlistViewModel>(context,
                                    listen: false)
                                .toggleItem(item.product.id);
                          },
                          child: Icon(Icons.cancel,size: ScreenUtil().setWidth(25),color: Color(0xffe1e1e1),),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(10),
                      ScreenUtil().setWidth(20), 0),
                  child: Text(
                    item.product.brand,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(
                        12,
                      ),
                      color: Color(0xffBB8738),
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
                  child: Text(item.product.name,
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            14,
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
                    "₹ " + item.product.price.toString() + " ",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          14,
                        ),
                        color: Color(0xff4a4a4a)),
                  ),
                  item.product.price < item.product.mrp
                      ? Text(
                          " ₹ " + item.product.mrp.toString(),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: ScreenUtil().setSp(
                                9,
                              ),
                              color: Color(0xff4a4a4a)),
                        )
                      : Container(),
                  item.product.price < item.product.mrp
                      ? Text(
                          " (${(100 - ((item.product.price / item.product.mrp) * 100)).toInt()} % off)",
                          style: TextStyle(
                              color: Color(0xff00d832),
                              fontSize: ScreenUtil().setSp(
                                8,
                              )),
                        )
                      : Container()
                ],
              ),
              SizedBox(height: ScreenUtil().setWidth(5),),
              Divider(height: ScreenUtil().setWidth(5),),
              InkWell(
                  onTap: () async {
                    await Provider.of<CartViewModel>(context, listen: false)
                        .cartAddItem(item.product.id, item.product.id, 1, false);
                    await Provider.of<WishlistViewModel>(context, listen: false)
                        .toggleItem(item.product.id);
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(183),
                    height: ScreenUtil().setWidth(30),
                    child: Center(
                      child: Text("MOVE TO BAG",style: TextStyle(color: Color(0xffBB8738)),),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
