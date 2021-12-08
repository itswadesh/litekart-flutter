import 'package:anne/values/colors.dart';
import 'package:anne/view_model/store_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../response_handler/orderReponse.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/graphQl.dart';
import '../../utility/locator.dart';
import '../../utility/query_mutation.dart';
import '../../values/route_path.dart' as routes;
import '../../components/widgets/cartEmptyMessage.dart';
import '../../components/widgets/errorMessage.dart';
import '../../components/widgets/loading.dart';

import '../../view/cart_logo.dart';
import '../../view_model/manage_order_view_model.dart';

class ManageOrder extends StatefulWidget {
  @override
  _ManageOrderState createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  var buttonOption = 1;
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  // List<ListItem> _dropdownItems = [
  //   ListItem(1, "2020 - 2021"),
  //   ListItem(2, "2021 - 2022"),
  //   ListItem(3, "2022 - 2023"),
  //   ListItem(4, "2023 - 2024")
  // ];
  //
  // List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  // ListItem _selectedItem;

  void initState() {
    super.initState();
    // _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    // _selectedItem = _dropdownMenuItems[0].value;
  }

  // List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
  //   List<DropdownMenuItem<ListItem>> items = [];
  //   for (ListItem listItem in listItems) {
  //     items.add(
  //       DropdownMenuItem(
  //         child: Text(
  //           listItem.name,
  //           style: TextStyle(fontSize: 12),
  //         ),
  //         value: listItem,
  //       ),
  //     );
  //   }
  //   return items;
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title:  Text(
          "Orders",
          style: TextStyle(
              color: Color(0xff616161),
              fontSize: ScreenUtil().setSp(
                21,
              ),),
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
        color: Color(0xfff3f3f3),
        child:  OrderClass()
      ))),
      // bottomSheet:  Container(
      //
      //     padding: EdgeInsets.all(20),
      //     width: double.infinity,
      //     color: Color(0xffba8638),
      //     child: Text("© 2020 Anne Private Limited",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)),
    );
  }
}

class OrderClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderClass();
  }
}

class _OrderClass extends State<OrderClass> {
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<OrderViewModel>(
        builder: (BuildContext context, value, Widget? child) {
          if (value.deliveredStatus == "loading") {
            Provider.of<OrderViewModel>(context, listen: false)
                .fetchDeliveredOrder();
            return Loading();
          } else if (value.deliveredStatus == "empty") {
            return Container(
              //height: MediaQuery.of(context).size.height-20,
                child: cartEmptyMessage("search", "No Orders Found"));
          } else if (value.deliveredStatus == "error") {
            return  Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: errorMessage()));
          } else {
            return ListOrderData(value.deliveredOrderResponse);
          }
        });
  }
}



class ListOrderData extends StatelessWidget{
  final OrderResponse? orderResponse;
 // final status;
  ListOrderData(this.orderResponse);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getProductList(orderResponse!);
  }

  Widget getProductList(OrderResponse orderResponse) {
    return Container(

        child: ListView.builder(
        itemCount: orderResponse.data!.length,
        itemBuilder: (BuildContext context, index) {
          return getProductCard(orderResponse.data![index],context);
        }));
  }

  getProductCard(OrderData orderData,context) {
    return Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
        child:  Material(
        color: Color(0xffffffff),
          // borderRadius: BorderRadius.circular(2),
          child: Card(

            elevation: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(19),
                  ScreenUtil().setWidth(0),
                  ScreenUtil().setWidth(19),
                  ScreenUtil().setWidth(10)),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                child: Column(
                   children: <Widget>[
                     ListTile(
                       contentPadding: EdgeInsets.only(left: 0),
                       title:   Text(
                                   orderData.items![0].status!,
                                   style: TextStyle(
                                     color: AppColors.primaryElement,
                                   ),
                                   textAlign: TextAlign.start,
                                 ),
                       subtitle: Text(
                                 "on ${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderData.createdAt!) * 1000))}",
                                 style: TextStyle(
                                     color: Color(0xff9b9b9b),
                                 fontSize: ScreenUtil().setSp(14)
                                 ))
                     ),
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Container(
                  //           width: ScreenUtil().setWidth(200),
                  //           child:
                  //           Text(
                  //             orderData.items[0].status,
                  //             style: TextStyle(
                  //               color: AppColors.primaryElement2,
                  //             ),
                  //             textAlign: TextAlign.start,
                  //           ),
                  //
                  //           ),
                  //       Text(
                  //           "${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderData.createdAt) * 1000))}",
                  //           style: TextStyle(
                  //               color: Color(0xff9b9b9b),
                  //               fontSize: ScreenUtil().setSp(
                  //                 16,
                  //               )))
                  //     ],
                  //   ),
                  //   SizedBox(
                  //     height: ScreenUtil().setWidth(16),
                  //   ),
                    getOrderItems(orderData.items!,orderData.address),

                    SizedBox(
                      height: ScreenUtil().setWidth(26),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Items : ${orderData.items!.length}",
                          style: TextStyle(
                              color: Color(0xff9b9b9b),
                              fontSize: ScreenUtil().setSp(
                                13,
                              )),
                        ),
                        Text(
                          "Total Amount : ${store!.currencySymbol} ${orderData.amount!.total!.toStringAsFixed(store!.currencyDecimals!)}",
                          style: TextStyle(
                              color: Color(0xff9b9b9b),
                              fontSize: ScreenUtil().setSp(
                                14,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Container(
                        //   height: ScreenUtil().setWidth(28),
                        //   width: ScreenUtil().setWidth(94),
                        //   child: RaisedButton(
                        //     padding: EdgeInsets.fromLTRB(
                        //         0,
                        //         ScreenUtil().setWidth(7),
                        //         0,
                        //         ScreenUtil().setWidth(7)),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(
                        //             ScreenUtil().setWidth(26)),
                        //         side: BorderSide(color: Color(0xffee7625))),
                        //     color: Colors.white,
                        //     textColor: Color(0xffee7625),
                        //     onPressed: () {},
                        //     child: Text(
                        //       "Details",
                        //       style: TextStyle(
                        //           fontSize: ScreenUtil().setSp(
                        //             14,
                        //           )),
                        //     ),
                        //   ),
                        // ),
                        Text(
                          "Order ID : ${orderData.orderNo}",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                13,
                              ),
                              color: Color(0xff9b9b9b)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  getOrderItems(List<OrderItems> items, OrderAddress? address) {
    return ListView.builder(
        itemCount: items.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder:(buildContext, index) {

     return Container(
         margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(2)),
         child: GestureDetector(
         onTap: (){
           locator<NavigationService>().pushNamed(routes.OrderTrack,args: {"id":items[index].id,"items":items[index],"address":address});

         },
         child: Container(
       // height: ScreenUtil().setWidth(126),
      // width: ScreenUtil().setWidth(388),

       padding: EdgeInsets.fromLTRB(
           ScreenUtil().setWidth(15),
           ScreenUtil().setWidth(12),
           ScreenUtil().setWidth(15),
           ScreenUtil().setWidth(8)),
       decoration: BoxDecoration(
         color: Color(0xfff7f7f7),
       ),
       child: Row(
         children: <Widget>[
           new ClipRRect(
               child: (items[index].img!=null && items[index].img!="")?  FadeInImage.assetNetwork(
                 imageErrorBuilder: ((context,object,stackTrace){

                   return Image.asset("assets/images/logo.png", fit: BoxFit.contain,
                     width: ScreenUtil().setWidth(92),
                     height: ScreenUtil().setWidth(112),);
                 }),
                 placeholder: 'assets/images/loading.gif',
                 image: items[index].img!,
                 fit: BoxFit.contain,
                 width: ScreenUtil().setWidth(92),
                 height: ScreenUtil().setWidth(112),
               ):Image.asset("assets/images/logo.png",fit: BoxFit.contain,
                 width: ScreenUtil().setWidth(92),
                 height: ScreenUtil().setWidth(112),)),
           Padding(
             padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
           ),
           Container(
             child: Expanded(
               child: Column(
                 children: <Widget>[
                   Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: <Widget>[
                         Container(
                           width: ScreenUtil().setWidth(230),
                           child: Text(
                             items[index].brandName ?? "",
                             style: TextStyle(
                               color: Color(0xff454545),
                               fontWeight: FontWeight.w600,
                               fontSize: ScreenUtil().setSp(17),
                             ),
                             textAlign: TextAlign.left,
                           ),
                         ),]),
                   SizedBox(
                     height: ScreenUtil().setWidth(8),
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       Container(
                         width: ScreenUtil().setWidth(230),
                         child: Text(
                           items[index].name!,
                           style: TextStyle(
                             fontWeight: FontWeight.w500,
                             color: Color(0xff616161),
                             fontSize: ScreenUtil().setSp(
                               17,
                             ),
                           ),
                           overflow: TextOverflow.ellipsis,
                           textAlign: TextAlign.left,
                         ),
                       ),

                     ],
                   ),

                   SizedBox(
                     height: ScreenUtil().setWidth(11),
                   ),
       Row(
         mainAxisAlignment: MainAxisAlignment.start,
         children: <Widget>[
                   Container(
                     width: ScreenUtil().setWidth(188),
                     child: Text(
                       "Qty : " + items[index].qty.toString(),
                       style: TextStyle(
                           fontWeight: FontWeight.w500,
                           color: AppColors.primaryElement,
                           fontSize: ScreenUtil().setSp(
                             14,
                           )),
                       textAlign: TextAlign.left,
                     ),
                   ),]),
                   SizedBox(
                     height: ScreenUtil().setWidth(10),
                   ),

                 ],
               ),
             ),
           )
         ],
       ),
     )));
    });
  }

}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
