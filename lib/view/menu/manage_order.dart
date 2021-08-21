import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

        title:  Text(
          "My Orders",
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
        color: Color(0xffe5e5e5),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Container(
                //   margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(27), ScreenUtil().setWidth(20), ScreenUtil().setWidth(16), ScreenUtil().setWidth(27)),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "Back to Home",
                //         style: TextStyle(
                //             decoration: TextDecoration.underline,
                //             color: Color(0xff2080dd),
                //             fontSize: ScreenUtil().setSp(14,)),
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           Text(
                //             "4 orders placed in ",
                //             style: TextStyle(fontSize: ScreenUtil().setSp(14,),color: Color(0xff1f1f1f)),
                //           ),
                //           Container(
                //               padding: EdgeInsets.only(left: 2),
                //               height: ScreenUtil().setWidth(26),
                //               color: Colors.white,
                //               child: DropdownButtonHideUnderline(
                //                   child: DropdownButton<ListItem>(
                //                       value: _selectedItem,
                //                       items: _dropdownMenuItems,
                //                       onChanged: (value) {
                //                         setState(() {
                //                           _selectedItem = value;
                //                         });
                //                       }))),
                //         ],
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: ScreenUtil().setWidth(20),
                ),
                // Container(
                //   margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(24), 0,
                //       ScreenUtil().setWidth(18), ScreenUtil().setWidth(35)),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Container(
                //         height: ScreenUtil().setWidth(40),
                //         child: RaisedButton(
                //           elevation: 1,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(
                //                 ScreenUtil().setWidth(25)),
                //           ),
                //           textColor:
                //               buttonOption == 1 ? Colors.white : Colors.grey,
                //           color: buttonOption == 1
                //               ? Color(0xffee7625)
                //               : Color(0xfff3f3f3),
                //           onPressed: () {
                //             setState(() {
                //               buttonOption = 1;
                //             });
                //           },
                //           child: Text(
                //             "  Delivered  ",
                //             style: TextStyle(
                //                 fontSize: ScreenUtil().setSp(
                //               14,
                //             )),
                //           ),
                //         ),
                //       ),
                //       SizedBox(width: 10,),
                //       Container(
                //         height: ScreenUtil().setWidth(40),
                //         child: RaisedButton(
                //           elevation: 1,
                //           // padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(
                //                 ScreenUtil().setWidth(25)),
                //           ),
                //           textColor:
                //               buttonOption == 2 ? Colors.white : Colors.grey,
                //           color: buttonOption == 2
                //               ? Color(0xffee7625)
                //               : Color(0xfff3f3f3),
                //           onPressed: () {
                //             setState(() {
                //               buttonOption = 2;
                //             });
                //           },
                //           child: Text(
                //             "  In-Track  ",
                //             style: TextStyle(
                //                 fontSize: ScreenUtil().setSp(
                //               14,
                //             )),
                //           ),
                //         ),
                //       ),
                //       SizedBox(width: 10,),
                //       Container(
                //         height: ScreenUtil().setWidth(40),
                //         child: RaisedButton(
                //           elevation: 1,
                //           // padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(
                //                 ScreenUtil().setWidth(25)),
                //           ),
                //           textColor:
                //               buttonOption == 3 ? Colors.white : Colors.grey,
                //           color: buttonOption == 3
                //               ? Color(0xffee7625)
                //               : Color(0xfff3f3f3),
                //           onPressed: () {
                //             setState(() {
                //               buttonOption = 3;
                //             });
                //           },
                //           child: Text(
                //             "  Pending  ",
                //             style: TextStyle(
                //                 fontSize: ScreenUtil().setSp(
                //               14,
                //             )),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
               // buttonOption == 1 ? DeliveredClass() : Container(),
                OrderClass()
                // buttonOption == 2 ? InTrackClass() : Container(),
                // buttonOption == 3 ? PendingClass() : Container(),
              ],
            ),
          ),
        ),
      ))),
      // bottomSheet:  Container(
      //
      //     padding: EdgeInsets.all(20),
      //     width: double.infinity,
      //     color: Color(0xffba8638),
      //     child: Text("© 2020 Tablez India Private Limited",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)),
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
        builder: (BuildContext context, value, Widget child) {
          if (value.deliveredStatus == "loading") {
            Provider.of<OrderViewModel>(context, listen: false)
                .fetchDeliveredOrder();
            return Loading();
          } else if (value.deliveredStatus == "empty") {
            return Container(
                child: cartEmptyMessage("search", "No Orders Found"));
          } else if (value.deliveredStatus == "error") {
            return Container(child: errorMessage());
          } else {
            return ListOrderData(value.deliveredOrderResponse);
          }
        });
  }
}

// class DeliveredClass extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _DeliveredClass();
//   }
// }

// class _DeliveredClass extends State<DeliveredClass> {
//   QueryMutation addMutation = QueryMutation();
//   GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Consumer<OrderViewModel>(
//         builder: (BuildContext context, value, Widget child) {
//           if (value.deliveredStatus == "loading") {
//             Provider.of<OrderViewModel>(context, listen: false).fetchDeliveredOrder();
//             return Loading();
//           } else if (value.deliveredStatus == "empty") {
//             return Container(child: cartEmptyMessage("search", "No Delivered Orders Found"));
//           } else if (value.deliveredStatus == "error") {
//             return Container(child: errorMessage());
//           } else {
//             return ListOrderData(value.deliveredOrderResponse,"Delivered");
//           }
//         });
//     // return GraphQLProvider(
//     //     client: graphQLConfiguration.initailizeClient(),
//     //     child: CacheProvider(
//     //         child: Container(
//     //       child: ListView.builder(
//     //           shrinkWrap: true,
//     //           physics: NeverScrollableScrollPhysics(),
//     //           itemCount: 1,
//     //           itemBuilder: (BuildContext context, index) {
//     //             return Query(
//     //                 options: QueryOptions(
//     //                     document: gql(addMutation.myOrders()),
//     //                     variables: {"status": "Delivered"}),
//     //                 builder: (QueryResult result,
//     //                     {VoidCallback refetch, FetchMore fetchMore}) {
//     //                   if (result.hasException) {
//     //                     print(result.exception.toString());
//     //                     return Container(child: errorMessage());
//     //                   }
//     //                   if (result.isLoading) {
//     //                     return Loading();
//     //                   }
//     //                   print(jsonEncode(result.data));
//     //
//     //                   if (result.data["myOrders"]['data'].length == 0) {
//     //                     return Container(
//     //                         child: cartEmptyMessage(
//     //                             "search", "No Pending Orders Found"));
//     //                   } else {
//     //                     return getProductList(result.data["myOrders"]["data"]);
//     //                   }
//     //                 });
//     //           }),
//     //     )));
//   }
//
//
//
//   // getProductCard(data) {
//   //   return GestureDetector(
//   //     onTap: () {},
//   //     child: Material(
//   //         color: Color(0xfff3f3f3),
//   //         // borderRadius: BorderRadius.circular(2),
//   //         child: Card(
//   //           margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(21), 0,
//   //               ScreenUtil().setWidth(22), ScreenUtil().setWidth(12)),
//   //           elevation: 0,
//   //           child: Container(
//   //             padding: EdgeInsets.fromLTRB(
//   //                 ScreenUtil().setWidth(24),
//   //                 ScreenUtil().setWidth(23),
//   //                 ScreenUtil().setWidth(19),
//   //                 ScreenUtil().setWidth(24)),
//   //             decoration: BoxDecoration(
//   //               color: Colors.white,
//   //             ),
//   //             child: Container(
//   //               child: Column(
//   //                 children: <Widget>[
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: <Widget>[
//   //                       Container(
//   //                           width: ScreenUtil().setWidth(200),
//   //                           child: Text(
//   //                             "${data['items'][0]["name"]}",
//   //                             style: TextStyle(
//   //                                 color: Color(0xff616161),
//   //                                 fontSize: ScreenUtil().setSp(
//   //                                   16,
//   //                                 )),
//   //                             overflow: TextOverflow.ellipsis,
//   //                           )),
//   //                       Text(
//   //                           "${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(data["createdAt"]) * 1000))}",
//   //                           style: TextStyle(
//   //                               color: Color(0xff9b9b9b),
//   //                               fontSize: ScreenUtil().setSp(
//   //                                 16,
//   //                               )))
//   //                     ],
//   //                   ),
//   //                   SizedBox(
//   //                     height: ScreenUtil().setWidth(16),
//   //                   ),
//   //                   Container(
//   //                     width: double.infinity,
//   //                     child: Text(
//   //                       "Order ID : ${data['orderNo']}",
//   //                       style: TextStyle(
//   //                           fontSize: ScreenUtil().setSp(
//   //                             13,
//   //                           ),
//   //                           color: Color(0xff9b9b9b)),
//   //                       textAlign: TextAlign.start,
//   //                       overflow: TextOverflow.ellipsis,
//   //                     ),
//   //                   ),
//   //                   SizedBox(
//   //                     height: ScreenUtil().setWidth(26),
//   //                   ),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: <Widget>[
//   //                       Text(
//   //                         "Quantity : ${data['amount']['qty']}",
//   //                         style: TextStyle(
//   //                             color: Color(0xff9b9b9b),
//   //                             fontSize: ScreenUtil().setSp(
//   //                               13,
//   //                             )),
//   //                       ),
//   //                       Text(
//   //                         "Total Amount : ₹ ${data["amount"]["total"]}",
//   //                         style: TextStyle(
//   //                             color: Color(0xff9b9b9b),
//   //                             fontSize: ScreenUtil().setSp(
//   //                               14,
//   //                             )),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   SizedBox(
//   //                     height: ScreenUtil().setWidth(16),
//   //                   ),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: [
//   //                       Container(
//   //                         height: ScreenUtil().setWidth(28),
//   //                         width: ScreenUtil().setWidth(94),
//   //                         child: RaisedButton(
//   //                           padding: EdgeInsets.fromLTRB(
//   //                               0,
//   //                               ScreenUtil().setWidth(7),
//   //                               0,
//   //                               ScreenUtil().setWidth(7)),
//   //                           shape: RoundedRectangleBorder(
//   //                               borderRadius: BorderRadius.circular(
//   //                                   ScreenUtil().setWidth(26)),
//   //                               side: BorderSide(color: Color(0xffee7625))),
//   //                           color: Colors.white,
//   //                           textColor: Color(0xffee7625),
//   //                           onPressed: () {},
//   //                           child: Text(
//   //                             "Details",
//   //                             style: TextStyle(
//   //                                 fontSize: ScreenUtil().setSp(
//   //                               14,
//   //                             )),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                       Text(
//   //                         "Delivered",
//   //                         style: TextStyle(
//   //                             color: Color(0xff00c32d),
//   //                             fontSize: ScreenUtil().setSp(
//   //                               14,
//   //                             )),
//   //                       ),
//   //                     ],
//   //                   )
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         )),
//   //   );
//   // }
//   //
//   // Widget getProductList(data) {
//   //   return ListView.builder(
//   //       physics: NeverScrollableScrollPhysics(),
//   //       shrinkWrap: true,
//   //       itemCount: data.length,
//   //       itemBuilder: (BuildContext context, index) {
//   //         return getProductCard(data[index]);
//   //       });
//   // }
// }
//
// class InTrackClass extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _InTrackClass();
//   }
// }
//
// class _InTrackClass extends State<InTrackClass> {
//   QueryMutation addMutation = QueryMutation();
//   GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Consumer<OrderViewModel>(
//         builder: (BuildContext context, value, Widget child) {
//           if (value.trackingStatus == "loading") {
//             Provider.of<OrderViewModel>(context, listen: false).fetchTrackingOrder();
//             return Loading();
//           } else if (value.trackingStatus == "empty") {
//             return Container(child: cartEmptyMessage("search", "No In-Track Orders Found"));
//           } else if (value.trackingStatus == "error") {
//             return Container(child: errorMessage());
//           } else {
//             return ListOrderData(value.trackingOrderResponse,"In-Track");
//           }
//         });
//     // return GraphQLProvider(
//     //     client: graphQLConfiguration.initailizeClient(),
//     //     child: CacheProvider(
//     //         child: Container(
//     //       child: ListView.builder(
//     //           shrinkWrap: true,
//     //           physics: NeverScrollableScrollPhysics(),
//     //           itemCount: 1,
//     //           itemBuilder: (BuildContext context, index) {
//     //             return Query(
//     //                 options: QueryOptions(
//     //                     document: gql(addMutation.myOrders()),
//     //                     variables: {"status": "Tracking"}),
//     //                 builder: (QueryResult result,
//     //                     {VoidCallback refetch, FetchMore fetchMore}) {
//     //                   if (result.hasException) {
//     //                     print(result.exception.toString());
//     //                     return Container(child: errorMessage());
//     //                   }
//     //                   if (result.isLoading) {
//     //                     return Loading();
//     //                   }
//     //                   print(jsonEncode(result.data));
//     //
//     //                   if (result.data["myOrders"]['data'].length == 0) {
//     //                     return Container(
//     //                         child: cartEmptyMessage(
//     //                             "search", "No Pending Orders Found"));
//     //                   } else {
//     //                     return getProductList(result.data["myOrders"]["data"]);
//     //                   }
//     //                 });
//     //           }),
//     //     )));
//   }
//
//   // getProductCard(data) {
//   //   print(data);
//   //   return GestureDetector(
//   //     onTap: () {},
//   //     child: Material(
//   //         color: Color(0xfff3f3f3),
//   //         // borderRadius: BorderRadius.circular(2),
//   //         child: Card(
//   //           margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(21), 0,
//   //               ScreenUtil().setWidth(22), ScreenUtil().setWidth(12)),
//   //           elevation: 0,
//   //           child: Container(
//   //             padding: EdgeInsets.fromLTRB(
//   //                 ScreenUtil().setWidth(24),
//   //                 ScreenUtil().setWidth(23),
//   //                 ScreenUtil().setWidth(19),
//   //                 ScreenUtil().setWidth(24)),
//   //             decoration: BoxDecoration(
//   //               color: Colors.white,
//   //             ),
//   //             child: Container(
//   //               child: Column(
//   //                 children: <Widget>[
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: <Widget>[
//   //                       Container(
//   //                           width: ScreenUtil().setWidth(200),
//   //                           child: Text(
//   //                             "${data['items'][0]["name"]}",
//   //                             style: TextStyle(
//   //                                 color: Color(0xff616161),
//   //                                 fontSize: ScreenUtil().setSp(
//   //                                   16,
//   //                                 )),
//   //                             overflow: TextOverflow.ellipsis,
//   //                           )),
//   //                       Text(
//   //                           "${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(data["createdAt"]) * 1000))}",
//   //                           style: TextStyle(
//   //                               color: Color(0xff9b9b9b),
//   //                               fontSize: ScreenUtil().setSp(
//   //                                 16,
//   //                               )))
//   //                     ],
//   //                   ),
//   //                   SizedBox(
//   //                     height: ScreenUtil().setWidth(16),
//   //                   ),
//   //                   Container(
//   //                     width: double.infinity,
//   //                     child: Text(
//   //                       "Order ID : ${data['orderNo']}",
//   //                       style: TextStyle(
//   //                           fontSize: ScreenUtil().setSp(
//   //                             13,
//   //                           ),
//   //                           color: Color(0xff9b9b9b)),
//   //                       textAlign: TextAlign.start,
//   //                       overflow: TextOverflow.ellipsis,
//   //                     ),
//   //                   ),
//   //                   SizedBox(
//   //                     height: ScreenUtil().setWidth(26),
//   //                   ),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: <Widget>[
//   //                       Text(
//   //                         "Quantity : ${data['amount']['qty']}",
//   //                         style: TextStyle(
//   //                             color: Color(0xff9b9b9b),
//   //                             fontSize: ScreenUtil().setSp(
//   //                               13,
//   //                             )),
//   //                       ),
//   //                       Text(
//   //                         "Total Amount : ₹ ${data["amount"]["total"]}",
//   //                         style: TextStyle(
//   //                             color: Color(0xff9b9b9b),
//   //                             fontSize: ScreenUtil().setSp(
//   //                               14,
//   //                             )),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   SizedBox(
//   //                     height: ScreenUtil().setWidth(16),
//   //                   ),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: [
//   //                       Container(
//   //                         height: ScreenUtil().setWidth(28),
//   //                         width: ScreenUtil().setWidth(94),
//   //                         child: RaisedButton(
//   //                           padding: EdgeInsets.fromLTRB(
//   //                               0,
//   //                               ScreenUtil().setWidth(7),
//   //                               0,
//   //                               ScreenUtil().setWidth(7)),
//   //                           shape: RoundedRectangleBorder(
//   //                               borderRadius: BorderRadius.circular(
//   //                                   ScreenUtil().setWidth(26)),
//   //                               side: BorderSide(color: Color(0xffee7625))),
//   //                           color: Colors.white,
//   //                           textColor: Color(0xffee7625),
//   //                           onPressed: () {},
//   //                           child: Text(
//   //                             "Details",
//   //                             style: TextStyle(
//   //                                 fontSize: ScreenUtil().setSp(
//   //                               14,
//   //                             )),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                       Container(
//   //                         height: ScreenUtil().setWidth(28),
//   //                         width: ScreenUtil().setWidth(94),
//   //                         child: RaisedButton(
//   //                           padding: EdgeInsets.fromLTRB(
//   //                               0,
//   //                               ScreenUtil().setWidth(7),
//   //                               0,
//   //                               ScreenUtil().setWidth(7)),
//   //                           shape: RoundedRectangleBorder(
//   //                               borderRadius: BorderRadius.circular(
//   //                                   ScreenUtil().setWidth(26)),
//   //                               side: BorderSide(color: Color(0xff00c32d))),
//   //                           color: Colors.white,
//   //                           textColor: Color(0xff00c32d),
//   //                           onPressed: () {},
//   //                           child: Text(
//   //                             "Re-Order",
//   //                             style: TextStyle(
//   //                                 fontSize: ScreenUtil().setSp(
//   //                               14,
//   //                             )),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                       Text(
//   //                         "In-Track",
//   //                         style: TextStyle(
//   //                             color: Color(0xff00c32d),
//   //                             fontSize: ScreenUtil().setSp(
//   //                               14,
//   //                             )),
//   //                       ),
//   //                     ],
//   //                   )
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         )),
//   //   );
//   // }
//   //
//   // Widget getProductList(data) {
//   //   return ListView.builder(
//   //       physics: NeverScrollableScrollPhysics(),
//   //       shrinkWrap: true,
//   //       itemCount: data.length,
//   //       itemBuilder: (BuildContext context, index) {
//   //         return getProductCard(data[index]);
//   //       });
//   // }
// }
//
// class PendingClass extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _PendingClass();
//   }
// }
//
// class _PendingClass extends State<PendingClass> {
//   QueryMutation addMutation = QueryMutation();
//   GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
//
//   @override
//   Widget build(BuildContext context) {
//
//    return Consumer<OrderViewModel>(
//        builder: (BuildContext context, value, Widget child) {
//      if (value.pendingStatus == "loading") {
//        Provider.of<OrderViewModel>(context, listen: false).fetchPendingOrder();
//        return Loading();
//      } else if (value.pendingStatus == "empty") {
//        return Container(child: cartEmptyMessage("search", "No Pending Orders Found"));
//      } else if (value.pendingStatus == "error") {
//        return Container(child: errorMessage());
//      } else {
//        return ListOrderData(value.pendingOrderResponse,"Pending");
//      }
//      });
//     // return GraphQLProvider(
//     //     client: graphQLConfiguration.initailizeClient(),
//     //     child: CacheProvider(
//     //         child: Container(
//     //       child: ListView.builder(
//     //           shrinkWrap: true,
//     //           physics: NeverScrollableScrollPhysics(),
//     //           itemCount: 1,
//     //           itemBuilder: (BuildContext context, index) {
//     //             return Query(
//     //                 options: QueryOptions(
//     //                     document: gql(addMutation.myOrders()),
//     //                     variables: {"status": "Pending"}),
//     //                 builder: (QueryResult result,
//     //                     {VoidCallback refetch, FetchMore fetchMore}) {
//     //                   if (result.hasException) {
//     //                     print(result.exception.toString());
//     //                     return Container(child: errorMessage());
//     //                   }
//     //                   if (result.isLoading) {
//     //                     return Loading();
//     //                   }
//     //                   print(jsonEncode(result.data));
//     //
//     //                   if (result.data["myOrders"]['data'].length == 0) {
//     //                     return Container(
//     //                         child: cartEmptyMessage(
//     //                             "search", "No Pending Orders Found"));
//     //                   } else {
//     //                     return getProductList(result.data["myOrders"]["data"]);
//     //                   }
//     //                 });
//     //           }),
//     //     )));
//   }
//
//   // getProductCard(data) {
//   //   return GestureDetector(
//   //     onTap: () {},
//   //     child: Material(
//   //         color: Color(0xfff3f3f3),
//   //         // borderRadius: BorderRadius.circular(2),
//   //         child: Card(
//   //           margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(21), 0,
//   //               ScreenUtil().setWidth(22), ScreenUtil().setWidth(12)),
//   //           elevation: 0,
//   //           child: Container(
//   //             padding: EdgeInsets.fromLTRB(
//   //                 ScreenUtil().setWidth(24),
//   //                 ScreenUtil().setWidth(23),
//   //                 ScreenUtil().setWidth(19),
//   //                 ScreenUtil().setWidth(24)),
//   //             decoration: BoxDecoration(
//   //               color: Colors.white,
//   //             ),
//   //             child: Container(
//   //               child: Column(
//   //                 children: <Widget>[
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: <Widget>[
//   //                       Container(
//   //                           width: ScreenUtil().setWidth(200),
//   //                           child: Text(
//   //                             "${data['items'][0]["name"]}",
//   //                             style: TextStyle(
//   //                                 color: Color(0xff616161),
//   //                                 fontSize: ScreenUtil().setSp(
//   //                                   16,
//   //                                 )),
//   //                             overflow: TextOverflow.ellipsis,
//   //                           )),
//   //                       Text(
//   //                           "${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(data["createdAt"]) * 1000))}",
//   //                           style: TextStyle(
//   //                               color: Color(0xff9b9b9b),
//   //                               fontSize: ScreenUtil().setSp(
//   //                                 16,
//   //                               )))
//   //                     ],
//   //                   ),
//   //                   SizedBox(
//   //                     height: ScreenUtil().setWidth(16),
//   //                   ),
//   //                   Container(
//   //                     width: double.infinity,
//   //                     child: Text(
//   //                       "Order ID : ${data['orderNo']}",
//   //                       style: TextStyle(
//   //                           fontSize: ScreenUtil().setSp(
//   //                             13,
//   //                           ),
//   //                           color: Color(0xff9b9b9b)),
//   //                       textAlign: TextAlign.start,
//   //                       overflow: TextOverflow.ellipsis,
//   //                     ),
//   //                   ),
//   //                   SizedBox(
//   //                     height: ScreenUtil().setWidth(26),
//   //                   ),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: <Widget>[
//   //                       Text(
//   //                         "Quantity : ${data['amount']['qty']}",
//   //                         style: TextStyle(
//   //                             color: Color(0xff9b9b9b),
//   //                             fontSize: ScreenUtil().setSp(
//   //                               13,
//   //                             )),
//   //                       ),
//   //                       Text(
//   //                         "Total Amount : ₹ ${data["amount"]["total"]}",
//   //                         style: TextStyle(
//   //                             color: Color(0xff9b9b9b),
//   //                             fontSize: ScreenUtil().setSp(
//   //                               14,
//   //                             )),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   SizedBox(
//   //                     height: ScreenUtil().setWidth(16),
//   //                   ),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: [
//   //                       Container(
//   //                         height: ScreenUtil().setWidth(28),
//   //                         width: ScreenUtil().setWidth(94),
//   //                         child: RaisedButton(
//   //                           padding: EdgeInsets.fromLTRB(
//   //                               0,
//   //                               ScreenUtil().setWidth(7),
//   //                               0,
//   //                               ScreenUtil().setWidth(7)),
//   //                           shape: RoundedRectangleBorder(
//   //                               borderRadius: BorderRadius.circular(
//   //                                   ScreenUtil().setWidth(26)),
//   //                               side: BorderSide(color: Color(0xffee7625))),
//   //                           color: Colors.white,
//   //                           textColor: Color(0xffee7625),
//   //                           onPressed: () {},
//   //                           child: Text(
//   //                             "Details",
//   //                             style: TextStyle(
//   //                                 fontSize: ScreenUtil().setSp(
//   //                               14,
//   //                             )),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                       Text(
//   //                         "Pending",
//   //                         style: TextStyle(
//   //                           color: Color(0xff00c32d),
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   )
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         )),
//   //   );
//   // }
//   //
//   // Widget getProductList(data) {
//   //   return ListView.builder(
//   //       physics: NeverScrollableScrollPhysics(),
//   //       shrinkWrap: true,
//   //       itemCount: data.length,
//   //       itemBuilder: (BuildContext context, index) {
//   //         return getProductCard(data[index]);
//   //       });
//   // }
// }

class ListOrderData extends StatelessWidget{
  final OrderResponse orderResponse;
 // final status;
  ListOrderData(this.orderResponse);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getProductList(orderResponse);
  }

  Widget getProductList(OrderResponse orderResponse) {
    return Container(

        child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: orderResponse.data.length,
        itemBuilder: (BuildContext context, index) {
          return getProductCard(orderResponse.data[index]);
        }));
  }

  getProductCard(OrderData orderData) {
    return GestureDetector(
      onTap: () {
        print("here");
      },
      child: Material(
        color: Color(0xffe5e5e5),
          // borderRadius: BorderRadius.circular(2),
          child: Card(
            margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(21), 0,
                ScreenUtil().setWidth(22), ScreenUtil().setWidth(12)),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(24),
                  ScreenUtil().setWidth(23),
                  ScreenUtil().setWidth(19),
                  ScreenUtil().setWidth(24)),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            width: ScreenUtil().setWidth(200),
                            child: Text(
                            "Order ID : ${orderData.orderNo}",
                              style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                              13,
                              ),
                              color: Color(0xff9b9b9b)),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                             ),
                            ),
                        Text(
                            "${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderData.createdAt) * 1000))}",
                            style: TextStyle(
                                color: Color(0xff9b9b9b),
                                fontSize: ScreenUtil().setSp(
                                  16,
                                )))
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(16),
                    ),
                    getOrderItems(orderData.items,orderData.address),

                    SizedBox(
                      height: ScreenUtil().setWidth(26),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Items : ${orderData.items.length}",
                          style: TextStyle(
                              color: Color(0xff9b9b9b),
                              fontSize: ScreenUtil().setSp(
                                13,
                              )),
                        ),
                        Text(
                          "Total Amount : ₹ ${orderData.amount.total}",
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
                          orderData.items[0].status,
                          style: TextStyle(
                            color: Color(0xff00c32d),
                          ),
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

  getOrderItems(List<OrderItems> items, OrderAddress address) {
    return ListView.builder(
        itemCount: items.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder:(buildContext, index) {

     return GestureDetector(
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
         color: Colors.white,
       ),
       child: Row(
         children: <Widget>[
           new ClipRRect(
               child: FadeInImage.assetNetwork(
                 placeholder: 'assets/images/loading.gif',
                 image: items[index].img,
                 fit: BoxFit.contain,
                 width: ScreenUtil().setWidth(92),
                 height: ScreenUtil().setWidth(102),
               )),
           Padding(
             padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
           ),
           Container(
             child: Expanded(
               child: Column(
                 children: <Widget>[
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Container(
                         width: ScreenUtil().setWidth(188),
                         child: Text(
                           items[index].name,
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

                     ],
                   ),
                   SizedBox(
                     height: ScreenUtil().setWidth(8),
                   ),
                   Container(
                     width: ScreenUtil().setWidth(188),
                     child: Text(
                       items[index].brandName ?? "",
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
                     width: ScreenUtil().setWidth(188),
                     child: Text(
                       "Qty : " + items[index].qty.toString(),
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

                 ],
               ),
             ),
           )
         ],
       ),
     ));
    });
  }

}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
