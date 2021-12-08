import 'dart:developer';

import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/enum/tz_dialog_type.dart';
import 'package:anne/response_handler/wishlistResponse.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/view_model/store_view_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../components/widgets/cartEmptyMessage.dart';
import '../../components/widgets/errorMessage.dart';
import '../../components/widgets/loading.dart';
import '../../main.dart';
import '../../utility/graphQl.dart';
import '../../view_model/cart_view_model.dart';
import '../../view_model/wishlist_view_model.dart';
import '../../view/cart_logo.dart';
import '../../view/product_detail.dart';
import '../../values/route_path.dart' as routes;
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
       // automaticallyImplyLeading: false,
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
              child: CartLogo(25)),
          SizedBox(width: ScreenUtil().setWidth(20),)
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
        builder: (BuildContext context, value, Widget? child) {

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
          padding: EdgeInsets.only(top: ScreenUtil().setWidth(5)),
            child:  Consumer<WishlistViewModel>(
                builder: (BuildContext context, value, Widget? child) {
              return PagedGridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio:
                        ScreenUtil().setWidth(183) / ScreenUtil().setWidth(290),
                    crossAxisCount: 2),
                pagingController: value.pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, dynamic item, index) => WishCard(item),
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
    return _WishCard();
  }
}

class _WishCard extends State<WishCard> {
  late WishlistData item;
  bool imageStatus = true;
  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
        border: Border.all(color: Color(0xffb1b1b1))
      ),
      child: InkWell(
        onTap: () async {
          locator<NavigationService>().pushNamed(routes.ProductDetailRoute,args: item.product!.id);
        },
        child: Container(
          width: ScreenUtil().setWidth(183),
          //     height: ScreenUtil().setWidth(269),
          height: ScreenUtil().setWidth(290),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    // child:  CachedNetworkImage(
                    //   fit: BoxFit.contain,
                    //     height: ScreenUtil().setWidth(213),
                    //     width: ScreenUtil().setWidth(193),
                    //   imageUrl: item.product!.img!+"?tr=w-193,fo-auto",
                    //   imageBuilder: (context, imageProvider) => Container(
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //         onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",  height: ScreenUtil().setWidth(213),
                    //           width: ScreenUtil().setWidth(193),
                    //           fit: BoxFit.contain,),
                    //
                    //         image: imageProvider,
                    //         fit: BoxFit.contain,
                    //
                    //       ),
                    //     ),
                    //   ),
                    //   placeholder: (context, url) => Image.asset("assets/images/loading.gif",  height: ScreenUtil().setWidth(213),
                    //     width: ScreenUtil().setWidth(193),
                    //     fit: BoxFit.contain,),
                    //   errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",  height: ScreenUtil().setWidth(213),
                    //     width: ScreenUtil().setWidth(193),
                    //     fit: BoxFit.contain,),
                    // ),
                 child:  FadeInImage.assetNetwork(
                      imageErrorBuilder: ((context,object,stackTrace){

                        return Image.asset("assets/images/logo.png",height: ScreenUtil().setWidth(213),
                          width: ScreenUtil().setWidth(193),
                          fit: BoxFit.contain,);
                      }),
                      placeholder: 'assets/images/loading.gif',
                      image: item.product!.img!,
                      height: ScreenUtil().setWidth(213),
                      width: ScreenUtil().setWidth(193),
                      fit: BoxFit.contain,
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
                            final NavigationService _navigationService = locator<NavigationService>();
                            TzDialog _dialog =
                            TzDialog(_navigationService.navigationKey.currentContext, TzDialogType.progress);
                            _dialog.show();
                            await Provider.of<WishlistViewModel>(context,
                                    listen: false)
                                .toggleItem(item.product!.id);
                            _dialog.close();
                          },
                          child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  0, 0, ScreenUtil().setWidth(0), 0),
                              width: ScreenUtil().radius(30),
                              height: ScreenUtil().radius(30),
                              decoration: new BoxDecoration(
                                color: Color(0xffd3d3d3),
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xfff3f3f3),
                                        width: ScreenUtil().setWidth(0.4)),
                                    top: BorderSide(
                                        color: Color(0xfff3f3f3),
                                        width: ScreenUtil().setWidth(0.4)),
                                    left: BorderSide(
                                        color: Color(0xfff3f3f3),
                                        width: ScreenUtil().setWidth(0.4)),
                                    right: BorderSide(
                                        color: Color(0xfff3f3f3),
                                        width: ScreenUtil().setWidth(0.4))),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Color(0xff454545),
                                size: ScreenUtil().setWidth(18),
                              ))),

                      ],
                    ),
                  )
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setWidth(10),
                      ScreenUtil().setWidth(20), 0),
                  child: Text(
                    item.product!.brand!,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(
                        14,
                      ),
                      color: Color(0xff616161),
                      fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  )),
              // SizedBox(
              //   height: ScreenUtil().setWidth(9),
              // ),
              // Container(
              //     width: MediaQuery.of(context).size.width,
              //     padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
              //         ScreenUtil().setWidth(20), 0),
              //     child: Text(item.product.name,
              //         style: TextStyle(
              //             color: Color(0xff5f5f5f),
              //             fontSize: ScreenUtil().setSp(
              //               14,
              //             )),
              //         overflow: TextOverflow.ellipsis,
              //         maxLines: 1)),
              SizedBox(
                height: ScreenUtil().setWidth(7),
              ),
      Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenUtil().setWidth(10),),
                  Text(
                    "${store!.currencySymbol} " + item.product!.price!.toStringAsFixed(store!.currencyDecimals!) + " ",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          14,
                        ),
                        fontWeight: FontWeight.w600,
                        color: Color(0xff4a4a4a)),
                  ),
                  item.product!.price! < item.product!.mrp!
                      ? Text(
                          " ${store!.currencySymbol} " + item.product!.mrp!.toStringAsFixed(store!.currencyDecimals!),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: ScreenUtil().setSp(
                                12,
                              ),
                              color: Color(0xff4a4a4a)),
                        )
                      : Container(),
                  item.product!.price! < item.product!.mrp!
                      ? Flexible(child: Text(
                          " (${(100 - ((item.product!.price! / item.product!.mrp!) * 100)).toInt()} % off)",
                          style: TextStyle(
                              color: AppColors.primaryElement2,
                              fontSize: ScreenUtil().setSp(
                                12,
                              )),
                    overflow: TextOverflow.ellipsis,
                        ))
                      : Container()
                ],
              )),
              SizedBox(height: ScreenUtil().setWidth(10),),
              Divider(height: ScreenUtil().setWidth(5),),
              InkWell(
                  onTap: () async {
                    final NavigationService _navigationService = locator<NavigationService>();
                    TzDialog _dialog =
                    TzDialog(_navigationService.navigationKey.currentContext, TzDialogType.progress);
                    _dialog.show();
                    await Provider.of<CartViewModel>(context, listen: false)
                        .cartAddItem(item.product!.id, item.product!.id, 1, false);
                    await Provider.of<WishlistViewModel>(context, listen: false)
                        .toggleItem(item.product!.id);

                    _dialog.close();

                  },
                  child: Container(
                    width: ScreenUtil().setWidth(183),
                    height: ScreenUtil().setWidth(35),
                    child: Center(
                      child: Text("MOVE TO BAG",style: TextStyle(color: AppColors.primaryElement,fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(16)),),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
