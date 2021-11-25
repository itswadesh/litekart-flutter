import 'package:anne/model/product.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/values/colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../main.dart';
import '../../values/route_path.dart' as routes;



class ProductCard extends StatefulWidget {
  final item;
  ProductCard(this.item);
  @override
  State<StatefulWidget> createState() {
    return _ProductCard();
  }
}

class _ProductCard extends State<ProductCard> with TickerProviderStateMixin{
  late ProductData  item;
  bool imageStatus = true;
  late AnimationController _controller ;
  @override
  void initState() {
    item = widget.item;
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 0));
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:ScreenUtil().setWidth(5)),
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
          border: Border.all(color: Color(0xffd1d1d1),width: 0.3),
      ),
      child: InkWell(
        onTap: () async {
          locator<NavigationService>().pushNamed(routes.ProductDetailRoute,args: item.id);
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => ProductDetail(item.id)));
        },
        child: Container(
          width: ScreenUtil().setWidth(183),
          //     height: ScreenUtil().setWidth(269),
          height: ScreenUtil().setWidth(288),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    // child:
                    // CachedNetworkImage(
                    //   fit: BoxFit.contain,
                    //   height: ScreenUtil().setWidth(193),
                    //   width: ScreenUtil().setWidth(193),
                    //   imageUrl: item.img!+"?tr=w-193,fo-auto",
                    //   imageBuilder: (context, imageProvider) => Container(
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //         onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",height: ScreenUtil().setWidth(193),
                    //         width: ScreenUtil().setWidth(193),
                    //         fit: BoxFit.contain,),
                    //
                    //         image: imageProvider,
                    //           fit: BoxFit.contain,
                    //
                    //       ),
                    //     ),
                    //   ),
                    //   placeholder: (context, url) => Image.asset("assets/images/loading.gif",height: ScreenUtil().setWidth(193),
                    //       width: ScreenUtil().setWidth(193),
                    //       fit: BoxFit.contain,),
                    //   errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",height: ScreenUtil().setWidth(193),
                    //           width: ScreenUtil().setWidth(193),
                    //           fit: BoxFit.contain,),
                    // ),
                    // child:ExtendedImage.network(
                    //   item.img!+"?tr=w-193,fo-auto",
                    //   height: ScreenUtil().setWidth(193),
                    //   width: ScreenUtil().setWidth(193),
                    //   fit: BoxFit.contain,
                    //   // cache: false,
                    //   // enableMemoryCache: false,
                    //   // clearMemoryCacheIfFailed: true,
                    //   // clearMemoryCacheWhenDispose: true,
                    //    cache: true,
                    //   loadStateChanged: (ExtendedImageState state) {
                    //     switch (state.extendedImageLoadState) {
                    //       case LoadState.loading:
                    //         _controller.reset();
                    //         return Image.asset(
                    //           "assets/images/loading.gif",
                    //           fit: BoxFit.contain,
                    //         );
                    //         break;
                    //
                    //     ///if you don't want override completed widget
                    //     ///please return null or state.completedWidget
                    //     //return null;
                    //     //return state.completedWidget;
                    //       case LoadState.completed:
                    //         _controller.forward();
                    //         return FadeTransition(
                    //           opacity: _controller,
                    //           child: ExtendedRawImage(
                    //             image: state.extendedImageInfo?.image,
                    //             height: ScreenUtil().setWidth(193),
                    //             width: ScreenUtil().setWidth(193),
                    //           ),
                    //         );
                    //         break;
                    //       case LoadState.failed:
                    //         _controller.reset();
                    //         return GestureDetector(
                    //           child:
                    //               Image.asset(
                    //                 "assets/images/logo.png",
                    //                 fit: BoxFit.contain,
                    //               ),
                    //           onTap: () {
                    //             state.reLoadImage();
                    //           },
                    //         );
                    //         break;
                    //     }
                    //   },
                    //   //cancelToken: cancellationToken,
                    // )
                    child:  FadeInImage.assetNetwork(
                      imageErrorBuilder: ((context,object,stackTrace){
                        return Image.asset("assets/images/logo.png",height: ScreenUtil().setWidth(193),
                          width: ScreenUtil().setWidth(193),
                          fit: BoxFit.contain,);
                      }),
                      placeholder: 'assets/images/loading.gif',
                      image: item.img!,
                      height: ScreenUtil().setWidth(193),
                      width: ScreenUtil().setWidth(193),
                      fit: BoxFit.contain,
                    )
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //   Container(
                  //       margin: EdgeInsets.fromLTRB(
                  //           0, ScreenUtil().setWidth(5), ScreenUtil().setWidth(5), 0),
                  //       width: ScreenUtil().radius(35),
                  //       height: ScreenUtil().radius(35),
                  //       decoration: new BoxDecoration(
                  //         color: Color(0xfff3f3f3),
                  //         border: Border(
                  //             bottom: BorderSide(
                  //                 color: Color(0xfff3f3f3),
                  //                 width: ScreenUtil().setWidth(0.4)),
                  //             top: BorderSide(
                  //                 color: Color(0xfff3f3f3),
                  //                 width: ScreenUtil().setWidth(0.4)),
                  //             left: BorderSide(
                  //                 color: Color(0xfff3f3f3),
                  //                 width: ScreenUtil().setWidth(0.4)),
                  //             right: BorderSide(
                  //                 color: Color(0xfff3f3f3),
                  //                 width: ScreenUtil().setWidth(0.4))),
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child:
                  //       CheckWishListClass(item.id, item.id)),
                  // ],)
                  
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
              ),
              Container(
                child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(10),
                          ScreenUtil().setWidth(20), 0),
                      child: Text(
                        item.brand == null
                            ? ""
                            : (item.brand!.name ?? ""),
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            12,
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
                      child: Text(item.name!,
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
                Container(
                    width: ScreenUtil().setWidth(183),
                    child:  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenUtil().setWidth(20),),
                      Text(
                        "${store!.currencySymbol} " + item.price.toString() + " ",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              14,
                            ),
                            fontWeight: FontWeight.w600,
                            color: Color(0xff4a4a4a)),
                      ),
                      item.price! < item.mrp!
                          ? Text(
                        " ${store!.currencySymbol} " + item.mrp.toString(),
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: ScreenUtil().setSp(
                              12,
                            ),
                            color: Color(0xff4a4a4a)),
                      )
                          : Container(),
                      item.price! < item.mrp!
                          ? Flexible(child: Text(
                        " (${(100 - ((item.price! / item.mrp!) * 100)).toInt()} % off)",
                        style: TextStyle(
                            color: AppColors.primaryElement2,
                            fontSize: ScreenUtil().setSp(
                              12,
                            ),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ))
                          : Container(),
                      SizedBox(width: ScreenUtil().setWidth(5),),
                    ],
                  )),
                  SizedBox(height: ScreenUtil().setWidth(19),),
                  // Divider(height: ScreenUtil().setWidth(5),),
                  // InkWell(
                  //     onTap: () async {
                  //       await Provider.of<CartViewModel>(context, listen: false)
                  //           .cartAddItem(item.id, item.id, 1, false);
                  //       await Provider.of<WishlistViewModel>(context, listen: false)
                  //           .toggleItem(item.id);
                  //     },
                  //     child: Container(
                  //       width: ScreenUtil().setWidth(183),
                  //       height: ScreenUtil().setWidth(30),
                  //       child: Center(
                  //         child: Text("MOVE TO BAG",style: TextStyle(color: Color(0xffBB8738)),),
                  //       ),
                  //     ))
                ],
              ),)

            ],
          ),
        ),
      ),
    );
  }

}
