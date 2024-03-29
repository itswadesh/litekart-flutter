import 'dart:developer';

import 'package:anne/response_handler/productListApiReponse.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/view/product_detail.dart';
import 'package:anne/view_model/cart_view_model.dart';
import 'package:anne/view_model/store_view_model.dart';
//import 'package:extended_image/extended_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../values/route_path.dart' as routes;

class ProductListCard extends StatefulWidget {
  final item;
  ProductListCard(this.item);
  @override
  State<StatefulWidget> createState() {
    return _ProductListCard();
  }
}

class _ProductListCard extends State<ProductListCard> {
   ProductListData? item;
 // bool imageStatus = true;
  @override
  void initState() {
    item = ProductListData.fromJson(widget.item);
   // log("product list "+item.imgCdn.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      margin: EdgeInsets.all(ScreenUtil().setWidth(2)),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
      //   //border: Border.all(color: Color(0xffb1b1b1)
      //   //),
      //
      // ),
      child: InkWell(
        onTap: () async {
          locator<NavigationService>()
              .pushNamed(routes.ProductDetailRoute, args: item!.id);
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => ProductDetail(item.id)));
        },
        child: Container(
          width: ScreenUtil().setWidth(203),
          //     height: ScreenUtil().setWidth(269),
          height: ScreenUtil().setWidth(255),
          child: Column(
            children: [
              Container(
              height: ScreenUtil().setWidth(203),
          width: ScreenUtil().setWidth(203),child: Stack(
                children: [
                  Container(
                    height: ScreenUtil().setWidth(203),
                    width: ScreenUtil().setWidth(203),
                    color: Color(0xffffffff),
                    child:
                    // CachedNetworkImage(
                    //   fit: BoxFit.contain,
                    //     height: ScreenUtil().setWidth(203),
                    //     width: ScreenUtil().setWidth(203),
                    //   imageUrl: item.imgCdn??""+"?tr=w-203,fo-auto",
                    //   imageBuilder: (context, imageProvider) => Container(
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //         onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",height: ScreenUtil().setWidth(203),
                    //           width: ScreenUtil().setWidth(203),
                    //           fit: BoxFit.contain,),
                    //
                    //         image: imageProvider,
                    //         fit: BoxFit.contain,
                    //
                    //       ),
                    //     ),
                    //   ),
                    //   placeholder: (context, url) => Image.asset("assets/images/loading.gif",height: ScreenUtil().setWidth(203),
                    //     width: ScreenUtil().setWidth(203),
                    //     fit: BoxFit.contain,),
                    //   errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",height: ScreenUtil().setWidth(203),
                    //     width: ScreenUtil().setWidth(203),
                    //     fit: BoxFit.contain,),
                    // ),
                     FadeInImage.assetNetwork(
                      placeholder: "assets/images/loading.gif",
                      image: item!.imgCdn??"",
                      imageErrorBuilder: ((context,object,stackTrace){

                        return Image.asset("assets/images/logo.png", height: ScreenUtil().setWidth(203),
                          width: ScreenUtil().setWidth(203),
                          fit: BoxFit.contain,);
                      }),
                      height: ScreenUtil().setWidth(203),
                      width: ScreenUtil().setWidth(203),
                      fit: BoxFit.contain,
                    ),
                    // ExtendedImage.network(
                    //   item.imgCdn,
                    //     height: ScreenUtil().setWidth(203),
                    //     width: ScreenUtil().setWidth(203),
                    //     fit: BoxFit.contain,
                    //  cache: true,
                    //  // enableMemoryCache: false,
                    //  // clearMemoryCacheIfFailed: true,
                    //  // clearMemoryCacheWhenDispose: true,
                    //  // cache: true,
                    //   //cancelToken: cancellationToken,
                    // )
                  ),
              //    Align(
               //       alignment: Alignment.bottomLeft,
               //       child:
               //  Container(
               //      margin: EdgeInsets.only(bottom: 2),
               //      child: Row(
               //     mainAxisAlignment: MainAxisAlignment.start,
               //     children: [
               //       SizedBox(
               //         width: ScreenUtil().setWidth(5),
               //       ),
               //       RatingClass(item.id),
               //     ],
               //   ))),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Container(
                  //         margin: EdgeInsets.fromLTRB(
                  //             0, ScreenUtil().setWidth(5), ScreenUtil().setWidth(5), 0),
                  //               width: ScreenUtil().radius(35),
                  //               height: ScreenUtil().radius(35),
                  //               decoration: new BoxDecoration(
                  //                 color: Color(0xfff3f3f3),
                  //                 border: Border(
                  //                     bottom: BorderSide(
                  //                         color: Color(0xfff3f3f3),
                  //                         width: ScreenUtil().setWidth(0.4)),
                  //                     top: BorderSide(
                  //                         color: Color(0xfff3f3f3),
                  //                         width: ScreenUtil().setWidth(0.4)),
                  //                     left: BorderSide(
                  //                         color: Color(0xfff3f3f3),
                  //                         width: ScreenUtil().setWidth(0.4)),
                  //                     right: BorderSide(
                  //                         color: Color(0xfff3f3f3),
                  //                         width: ScreenUtil().setWidth(0.4))),
                  //                 shape: BoxShape.circle,
                  //               ),
                  //               child:
                  //               CheckWishListClass(item.id, item.id))]),
                  // Container(
                  //   padding: EdgeInsets.only(
                  //       right: ScreenUtil().setWidth(10),
                  //       top: ScreenUtil().setWidth(10)),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       InkWell(
                  //         onTap: () async {
                  //           await Provider.of<WishlistViewModel>(context,
                  //               listen: false)
                  //               .toggleItem(item.id);
                  //         },
                  //         child: Icon(Icons.cancel,size: ScreenUtil().setWidth(25),color: Color(0xffe1e1e1),),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              )),
              Container(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(15),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(15),
                          0),
                      child:
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                            Text(
                              item!.brand == null ? "" : (item!.brand ?? ""),
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(
                                  16,
                                ),
                                color: Color(0xff5d5d5d),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            //CheckWishListClass(item.id, item.id)
                          // ]),
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(5),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15),
                            0, ScreenUtil().setWidth(15), 0),
                        child: Text(item!.name!,
                            style: TextStyle(
                                color: Color(0xff7f7f7f),
                                fontSize: ScreenUtil().setSp(
                                  13,
                                )),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),
                    SizedBox(
                      height: ScreenUtil().setWidth(7),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ScreenUtil().setWidth(15),
                        ),
                        Text(
                          "${store!.currencySymbol} " + item!.price!.toStringAsFixed(store!.currencyDecimals!) + " ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                14,
                              ),
                              fontWeight: FontWeight.w600,
                              color: Color(0xff4a4a4a)),
                        ),
                        item!.price! < item!.mrp!
                            ? Text(
                                " ${store!.currencySymbol} " + item!.mrp!.toStringAsFixed(store!.currencyDecimals!),
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: ScreenUtil().setSp(
                                      12,
                                    ),
                                    color: Color(0xff4a4a4a)),
                              )
                            : Container(),
                        item!.price! < item!.mrp!
                            ? Text(
                                " (${(100 - ((item!.price! / item!.mrp!) * 100)).toInt()} % off)",
                                style: TextStyle(
                                    color: AppColors.primaryElement2,
                                    fontSize: ScreenUtil().setSp(
                                      12,
                                    )),
                              )
                            : Container()
                      ],
                    ),
                    // SizedBox(
                    //   height: ScreenUtil().setWidth(5),
                    // ),


                    // SizedBox(height: ScreenUtil().setWidth(19),),
                    //  Divider(height: ScreenUtil().setWidth(10),),
                    //  InkWell(
                    //      onTap: () async {
                    //        if(item.stock>0) {
                    //          await Provider.of<CartViewModel>(
                    //              context, listen: false)
                    //              .cartAddItem(item.id, item.id, 1, false);
                    //        }
                    //      },
                    //      child: Container(
                    //        width: ScreenUtil().setWidth(183),
                    //        height: ScreenUtil().setWidth(29),
                    //        child: Center(
                    //          child: Text(item.stock>0?"MOVE TO BAG":"OUT OF STOCK",style: TextStyle(color: AppColors.primaryElement),),
                    //        ),
                    //      ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
