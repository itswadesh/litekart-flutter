import 'package:anne/components/widgets/buttonValue.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/view_model/schedule_view_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../components/widgets/cartEmptyMessage.dart';
import '../../components/widgets/errorMessage.dart';
import '../../components/widgets/loading.dart';
import '../../response_handler/orderReponse.dart';
import '../../response_handler/orderTrackResponse.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../view_model/manage_order_view_model.dart';
import '../../values/route_path.dart' as routes;
import '../utility/theme.dart';
import 'cart_logo.dart';

class OrderTracking extends StatefulWidget {
  final id;
  final items;
  final address;
  OrderTracking(this.id,this.items,this.address);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderTracking();
  }
}

class _OrderTracking extends State<OrderTracking> {

  @override
  void initState() {
    Provider.of<OrderViewModel>(context, listen: false)
        .changeTrackStatus();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () { Navigator.pop(context);},
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
        title: Center(
            // width: MediaQuery.of(context).size.width * 0.39,
            child: Text(
          "Order Tracking",
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
              child: CartLogo(25))
        ],
      ),
      body:

      Container(
          height: MediaQuery.of(context).size.height,
       //   color: Color(0xfff3f3f3),
          child: Consumer<OrderViewModel>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.trackOrderStatus == "loading") {
                  Provider.of<OrderViewModel>(context, listen: false).fetchOrderTrack(widget.id);
                  return Loading();
                }
                if (value.trackOrderStatus == "empty") {
                  return cartEmptyMessage(
                      "noNetwork", "Nothing here . Something went wrong !!");
                }
                if (value.trackOrderStatus == "error") {
                  return errorMessage();
                }
                return getOrderTrackDetails(value.orderTrackResponse!);
              })));


  }

  getProductCard(OrderTrackResponse orderTrackResponse) {

    double progressIndi = 0.05;
    if(orderTrackResponse.orderHistory![5].time!=null){
      progressIndi  = 1.0;
    }
    else if(orderTrackResponse.orderHistory![1].time!=null||orderTrackResponse.orderHistory![2].time!=null||orderTrackResponse.orderHistory![3].time!=null
    ||orderTrackResponse.orderHistory![4].time!=null){
      progressIndi = 0.5;
    }
    else if(orderTrackResponse.orderHistory![0].time!=null){
      progressIndi = 0.05;
    }
    return GestureDetector(
      onTap: () {},
      child:Material(
     // color: Color(0xffe5e5e5),
      // borderRadius: BorderRadius.circular(2),
      child: Card(

        shape:Border(

          top: BorderSide(color: AppColors.primaryElement),
          bottom: BorderSide(color: AppColors.primaryElement),
          left: BorderSide(color: AppColors.primaryElement),
          right: BorderSide(color: AppColors.primaryElement)
        ),
      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(22), 0,
      ScreenUtil().setWidth(22), ScreenUtil().setWidth(12)),
      elevation: 0,
      child: Container(
      padding: EdgeInsets.fromLTRB(
      ScreenUtil().setWidth(22),
      ScreenUtil().setWidth(22),
      ScreenUtil().setWidth(22),
      ScreenUtil().setWidth(22)),
    decoration: BoxDecoration(
    color: Colors.white,
    ),
    child: Container(
    child: Column(
    children: <Widget>[
                getOrderItems(widget.items),
                SizedBox(
                  height: ScreenUtil().setWidth(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                orderTrackResponse.orderHistory![0].time!=null?"${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderTrackResponse.orderHistory![0].time!) * 1000))}":"",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(11),
                              color:Color(0xff989898)
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(8),
                        ),
                        Text(
                          "Ordered",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(12),
                            color:Color(0xff494949)
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          orderTrackResponse.orderHistory![1].time!=null?"${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderTrackResponse.orderHistory![1].time!) * 1000))}":"",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(11),
                              color:Color(0xff989898)
                          ),
                        ),
                        SizedBox(
                          height:  ScreenUtil().setWidth(8),
                        ),
                        Text(
                          "Processed",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color:Color(0xff494949)
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          orderTrackResponse.orderHistory![5].time!=null?"${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderTrackResponse.orderHistory![5].time!) * 1000))}":"",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(11),
                              color:Color(0xff989898)
                          ),
                        ),
                        SizedBox(
                          height:  ScreenUtil().setWidth(8),
                        ),
                        Text(
                          "Delivered",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color:Color(0xff494949)
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox( height: ScreenUtil().setWidth(17),),
                LinearPercentIndicator(

                  center: progressIndi==0.5? Icon(
                    Icons.adjust_sharp,
                    size: ScreenUtil().setWidth(16),
                    color: Colors.white,
                  ):Container(),
                  lineHeight: ScreenUtil().setWidth(22),
                  percent: progressIndi,
                  backgroundColor: Color(0xfff3f3f3),
                  progressColor: AppColors.primaryElement,
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(17),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (orderTrackResponse.returnValidTill!=null && int.parse(orderTrackResponse.returnValidTill!)>=DateTime.now().millisecondsSinceEpoch && orderTrackResponse.orderHistory![6].time==null)?
                    InkWell(
                        onTap: (){
                        locator<NavigationService>().pushNamed(routes.ReturnPageRoute,args: {
                          "id":orderTrackResponse.orderId,
                          "pid":orderTrackResponse.pid,
                          "qty":orderTrackResponse.qty
                        });
                        },
                        child:Text(
                      "Return Item",
                      style: TextStyle(
                          fontSize: ScreenUtil().setWidth(13),
                          color: AppColors.primaryElement),
                    ))
                        :Container()
                    ,
                    Text(
                      "Order ID : #${orderTrackResponse.orderId}",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(13),
                          color:Color(0xff989898)
                      ),
                    )
                  ],
                )
              ]),
            ),
          )),
    ));
  }


  getOrderItems(OrderItems items) {

    return  InkWell(
        onTap: () async {
      await locator<NavigationService>()
    .pushNamed(routes.ProductDetailRoute, args: items.pid);
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
                      imageErrorBuilder: ((context,object,stackTrace){
                        return Image.asset("assets/images/logo.png");
                      }),
                      placeholder: 'assets/images/loading.gif',
                      image: items.img!,
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
                                items.name!,
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
                            items.brandName ?? "",
                            style: TextStyle(
                              color: AppColors.primaryElement,
                              fontSize: ScreenUtil().setWidth(13),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(8),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(188),
                          child: Text(
                            "Qty : " + items.qty.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryElement2,
                                fontSize: ScreenUtil().setSp(
                                  14,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(8),
                        ),
                       InkWell(
                         onTap: ()async{
                           await scheduleAlertBox(items.pid,items.name);
                         },
                         child: Container(
                          width: ScreenUtil().setWidth(188),
                          child: Text(
                            "Schedule Demo",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: ScreenUtil().setWidth(13),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                       )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));

  }

  getUpdatesCard(OrderTrackResponse orderTrackResponse) {
    int progressStep = 1;

    if(orderTrackResponse.orderHistory![8].time!=null){
      progressStep  = 6;
    }
    else if(orderTrackResponse.orderHistory![6].time!=null){
      progressStep  = 5;
    }
   else if(orderTrackResponse.orderHistory![5].time!=null){
      progressStep  = 4;
    }
    else if(orderTrackResponse.orderHistory![3].time!=null){
      progressStep = 3;
    }
    else if(orderTrackResponse.orderHistory![2].time!=null){
      progressStep = 2;
    }
    else if(orderTrackResponse.orderHistory![0].time!=null){
      progressStep = 1;
    }
    return GestureDetector(
      onTap: () {},
      child: Material(
        //  color: Color(0xfff3f3f3),
          // borderRadius: BorderRadius.circular(2),
          child: Card(
            margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(3)),
                      height: ScreenUtil().setWidth(15),
                      width: ScreenUtil().setWidth(15),
                      decoration:BoxDecoration(
                  color: Color(0x55f84b6d),
                        borderRadius: BorderRadius.circular(10),
              ),
                      child: Container(
                        height: ScreenUtil().setWidth(12),
                        width: ScreenUtil().setWidth(12),
                        decoration:BoxDecoration(
                          color: AppColors.primaryElement,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(8),
                    ),
                    Text(
                      "Updates",
                      style: TextStyle(
                        color: Color(0xff5f5f5f),
                        fontSize:ScreenUtil().setWidth(17)
                      )
                    )
                  ],
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 65,
                            ),
                            Container(
                              height: 75,
                              child: Text(
                                "Ordered",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 75,
                              child: Text(
                                "Packed",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 75,
                              child: Text(
                                "Shipped",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),

                            Container(
                              height: 75,
                              child: Text(
                                "Delivered",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            orderTrackResponse.orderHistory![6].time!=null?  Container(
                              height: 75,
                              child: Text(
                                "Return Initiated",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ):Container(),
                            orderTrackResponse.orderHistory![6].time!=null?  Container(
                              height: 75,
                              child: Text(
                                "Return Done",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ):Container(),
                          ],
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Color(0xfff3f3f3),
                              borderRadius: BorderRadius.circular(10)),
                          width: 14,
                          child: StepProgressIndicator(
                            totalSteps: orderTrackResponse.orderHistory![6].time!=null? 6:4,
                            currentStep: progressStep,
                            size: 15,
                            padding: 0,
                            selectedColor: Colors.transparent,
                            unselectedColor: Color(0xfff3f3f3),
                            fallbackLength: orderTrackResponse.orderHistory![6].time!=null? 450:300,
                            roundedEdges: Radius.circular(10),
                            direction: Axis.vertical,
                            customStep: (index, color, _) =>
                                color == Colors.transparent
                                    ? Container(
                                        color: color,
                                        child: Icon(
                                          Icons.circle,
                                          color: AppColors.primaryElement,
                                          size: 14,
                                        ),
                                      )
                                    : Container(
                                        color: color,
                                        child: Icon(
                                          Icons.circle,
                                          color: Color(0xffd2d2d2),
                                          size: 14,
                                        ),
                                      ),
                          )),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 65,
                            ),
                            Container(
                              height: 75,
                              child: Text(
                                  orderTrackResponse.orderHistory![0].time!=null?"${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderTrackResponse.orderHistory![0].time!) * 1000))}":"",

                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 75,
                              child: Text(
                                orderTrackResponse.orderHistory![2].time!=null?"${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderTrackResponse.orderHistory![2].time!) * 1000))}":"",

                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 75,
                              child: Text(
                                  orderTrackResponse.orderHistory![3].time!=null?"${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderTrackResponse.orderHistory![3].time!) * 1000))}":"",
                                  
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 75,
                              child: Text(
                                  orderTrackResponse.orderHistory![5].time!=null?"${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderTrackResponse.orderHistory![5].time!) * 1000))}":"",
                                  
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            orderTrackResponse.orderHistory![6].time!=null?
                            Container(
                              height: 75,
                              child: Text(
                                orderTrackResponse.orderHistory![6].time!=null?"${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderTrackResponse.orderHistory![6].time!) * 1000))}":"",

                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ):Container(),
                            orderTrackResponse.orderHistory![6].time!=null?
                            Container(
                              height: 75,
                              child: Text(
                                orderTrackResponse.orderHistory![8].time!=null?"${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orderTrackResponse.orderHistory![8].time!) * 1000))}":"",

                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ):Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                orderTrackResponse.orderHistory![5].time==null?  Container(
                  padding: EdgeInsets.all(14),
                  color: Color(0xfff3f3f3),
                  child: Text(
                    "Your Order will arrive on ${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch((int.parse(orderTrackResponse.orderHistory![0].time!) * 1000)+(86400000000*7)))}",
                    style: ThemeApp().textThemeGrey(),
                  ),
                ):Container(),

                orderTrackResponse.orderHistory![5].time!=null? InkWell(
                    onTap: () async {
                      await locator<NavigationService>().pushNamed(
                          routes.AddReviewRoute,
                          args: orderTrackResponse.pid);
                    },
                    child: Container(
                    padding: EdgeInsets.all(14),
                    color: Color(0xfff3f3f3),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(FontAwesomeIcons.star,color: Colors.amber,size: ScreenUtil().setWidth(20),),
                      SizedBox(width: ScreenUtil().setWidth(10),),
                      Container(
                    child:  Text(
                          "Rate This Product",
                          style: TextStyle(
                              color: AppColors.primaryElement,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(
                                16,
                              )),
                        ))]))):Container(),

              ]),
            ),
          )),
    );
  }
  getPaymentInfoCard(OrderAddress address) {
    return  GestureDetector(
            onTap: () {},
            child: Material(
             //   color: Color(0xfff3f3f3),
                // borderRadius: BorderRadius.circular(2),
                child: Card(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(32),
                        ScreenUtil().setWidth(39),
                        ScreenUtil().setWidth(49),
                        ScreenUtil().setWidth(35)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Billing Information",
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                17,
                              ),
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      // SizedBox(
                      //   height: ScreenUtil().setWidth(28),
                      // ),
                      // Container(
                      //     width: double.infinity,
                      //     child: Text("Payment Method",
                      //         style: TextStyle(
                      //             fontSize: ScreenUtil()
                      //                 .setSp(15, ),
                      //             color: Color(0xffee7625),
                      //             decoration: TextDecoration.underline),
                      //         textAlign: TextAlign.left)),
                      // ListTile(
                      //   leading: Image.asset(
                      //     "assets/images/visa.png",
                      //     height: 60,
                      //   ),
                      //   title: Text(
                      //     "XXXX XXXX XXXX XX36",
                      //     style: ThemeApp().textThemeSemiGrey(),
                      //   ),
                      //   subtitle: Text(
                      //     "Exp: 12/2035",
                      //     style: ThemeApp().textThemeSemiGrey(),
                      //   ),
                      // ),
                      SizedBox(height: ScreenUtil().setWidth(30)),
                      Container(
                        width: double.infinity,
                        child: Text("Billing Address",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(
                                  15,
                                ),
                                color: AppColors.primaryElement,
                                decoration: TextDecoration.underline),
                            textAlign: TextAlign.left),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(19),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "${address.firstName! + " " + address.lastName! ?? "User"}",
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(6),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Address : " + address.address.toString(),
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(6),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Pin : " + address.zip.toString(),
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(6),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          address.phone.toString(),
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(6),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          address.email.toString(),
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                        ),
                      ),
                    ]),
                  ),
                )),
          );

  }

  getDeliveryCard(OrderAddress address) {
    return GestureDetector(
            onTap: () {},
            child: Material(
            //    color: Color(0xfff3f3f3),
                // borderRadius: BorderRadius.circular(2),
                child: Card(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(32),
                        ScreenUtil().setWidth(39),
                        ScreenUtil().setWidth(49),
                        ScreenUtil().setWidth(35)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Shipping Information",
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                17,
                              ),
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(28),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("Type: Basic Delivery",
                            style: TextStyle(
                                color: AppColors.primaryElement,
                                fontSize: ScreenUtil().setSp(
                                  15,
                                )),
                            textAlign: TextAlign.left),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(21),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "${address.firstName! + " " + address.lastName! ?? "User"}",
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(6),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Address : " + address.address.toString(),
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(6),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Pin : " + address.zip.toString(),
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(6),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          address.phone.toString(),
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(6),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          address.email.toString(),
                          style: TextStyle(
                              color: Color(0xff5f5f5f),
                              fontSize: ScreenUtil().setSp(
                                15,
                              )),
                        ),
                      ),
                    ]),
                  ),
                )),
          );
  }

  Widget getOrderTrackDetails(OrderTrackResponse orderTrackResponse) {
    return Container(
     // color: Color(0xfff3f3f3),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setWidth(25),),
            // Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(21), ScreenUtil().setWidth(25), ScreenUtil().setWidth(28), ScreenUtil().setWidth(24)),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         // Text(
            //         //   "Back to Orders",
            //         //   style: TextStyle(
            //         //       decoration: TextDecoration.underline,
            //         //       color: Color(0xff2080DD),
            //         //       fontSize: ScreenUtil().setSp(14)),
            //         // ),
            //         Text(
            //           "Track orders, return items",
            //           style: TextStyle(
            //             color: Color(0xff616161),
            //             fontSize: ScreenUtil().setSp(14)
            //           ),
            //         ),
            //       ],
            //     )),
            getProductCard(orderTrackResponse),
            getUpdatesCard(orderTrackResponse),
            getPaymentInfoCard(widget.address),
            getDeliveryCard(widget.address),
            // Container(
            //   //height: 70,
            //   child:  Container(
            //             padding: EdgeInsets.all(20),
            //             width: double.infinity,
            //             color: AppColors.primaryElement,
            //             child: Text(
            //               "© 2020 Anne Private Limited",
            //               style: TextStyle(color: Colors.white),
            //               textAlign: TextAlign.center,
            //             )),
            //
            // )
          ],
        ),
      ),
    );
  }

  scheduleAlertBox(String? pid,title) {
    bool buttonStatus = true;
    final format = DateFormat("yyyy-MM-dd HH:mm");
    TextEditingController dateController = TextEditingController();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Schedule Demo",
                    style: TextStyle(
                        color: Color(0xff3a3a3a),
                        fontSize: ScreenUtil().setSp(17)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: ScreenUtil().setWidth(20),
                      color: Color(0xff3a3a3a),
                    ),
                  ),
                ],
              ),
              content: Container(
                child: Consumer<ScheduleViewModel>(
                    builder: (BuildContext context, value, Widget? child) {

                      return Container(
                        height: ScreenUtil().setWidth(180),
                        width: ScreenUtil().setWidth(386),
                        child: Column(
                          children: [
                            Divider(
                              height: ScreenUtil().setWidth(0.4),
                              thickness: ScreenUtil().setWidth(0.4),
                              color: Color(0xff707070),
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(25),
                            ),
                            DateTimeField(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding:
                                  EdgeInsets.all(ScreenUtil().setWidth(12)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  labelText: "Date and Time",
                                  labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(
                                        15,
                                      ))

                              ),
                              controller: dateController,
                              format: format,
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (date != null) {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime:
                                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                  );
                                  return DateTimeField.combine(date, time);
                                } else {
                                  return currentValue;
                                }
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(44),
                            ),
                            // Text("Maximum saving : ${store.currencySymbol} 125",style: TextStyle(color:Color(0xff7a7a7a),fontSize: ScreenUtil().setSp(13)),),
                            // SizedBox(height: ScreenUtil().setWidth(9),),
                            Container(
                              height: ScreenUtil().setWidth(36),
                              width: ScreenUtil().setWidth(224),
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(
                                    0,
                                    ScreenUtil().setWidth(9),
                                    0,
                                    ScreenUtil().setWidth(9)),
                                onPressed: () async {
                                  if (dateController.text != "" && dateController.text !=null && buttonStatus) {
                                    setState(() {
                                      buttonStatus = !buttonStatus;
                                    });
                                    await Provider.of<ScheduleViewModel>(context,
                                        listen: false).saveScheduleDemo("new", pid, dateController.text,title);
                                    if(Provider.of<ScheduleViewModel>(context,
                                        listen: false).saveStatus){
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.black,
                                        content:  Text(
                                            "Video Call Scheduled Successfully",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil().setSp(14)),
                                          ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                    else{
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.black,
                                        content:  Text(
                                          "Something went wrong !!",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(14)),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                color: AppColors.primaryElement2,
                                child: buttonValueWhite(
                                  "Schedule Demo",
                                  buttonStatus,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ));
        });
  }
}
