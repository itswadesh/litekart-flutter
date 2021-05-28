import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../utility/theme.dart';
import 'cart_logo.dart';

class OrderTracking extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderTracking();
  }
}

class _OrderTracking extends State<OrderTracking> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              child: CartLogo())
        ],
      ),
      body: Container(
        color: Color(0xfff3f3f3),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Back to Orders",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 13),
                      ),
                      Text(
                        "Track orders, return items",
                        style: ThemeApp().textThemeSemiGrey(),
                      ),
                    ],
                  )),
              getProductCard(),
              getUpdatesCard(),
              getPaymentInfoCard(),
              getDeliveryCard(),
              Container(
                height: 70,
                child: Expanded(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      color: Color(0xffba8638),
                      child: Text(
                        "© 2020 anne India Private Limited",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  getProductCard() {
    return GestureDetector(
      onTap: () {},
      child: Material(
          color: Color(0xfff3f3f3),
          // borderRadius: BorderRadius.circular(2),
          child: Card(
            margin: EdgeInsets.all(20),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(children: [
                Row(
                  children: <Widget>[
                    new ClipRRect(
                        borderRadius: new BorderRadius.circular(10.0),
                        child: Image.asset(
                          "assets/images/toyCart.jpeg",
                          fit: BoxFit.fitWidth,
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.width * 0.20,
                        )),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Container(
                      child: Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "My pet Dinosaur for kids",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Bruin",
                                  style: TextStyle(
                                      color: Color(0xffee7625), fontSize: 11),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Price ₹ 1899.00",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff00c32d),
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "12/02/2025",
                          style: ThemeApp().textThemeSemiGreySmall(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Ordered",
                          style: ThemeApp().textSemiBoldThemeSmall(),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "15/02/2025",
                          style: ThemeApp().textThemeSemiGreySmall(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Processed",
                          style: ThemeApp().textSemiBoldThemeSmall(),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "",
                          style: ThemeApp().textThemeSemiGreySmall(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Delivered",
                          style: ThemeApp().textSemiBoldThemeSmall(),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                LinearPercentIndicator(
                  center: Icon(
                    Icons.adjust_sharp,
                    size: 12,
                    color: Colors.white,
                  ),
                  lineHeight: 20.0,
                  percent: 0.5,
                  backgroundColor: Color(0xfff3f3f3),
                  progressColor: Color(0xff00c32d),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Return Item",
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Order ID : #duhsugsuss",
                      style: ThemeApp().textThemeSemiGreySmall(),
                    )
                  ],
                )
              ]),
            ),
          )),
    );
  }

  getUpdatesCard() {
    return GestureDetector(
      onTap: () {},
      child: Material(
          color: Color(0xfff3f3f3),
          // borderRadius: BorderRadius.circular(2),
          child: Card(
            margin: EdgeInsets.all(20),
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
                    Icon(
                      Icons.adjust_sharp,
                      color: Colors.blue,
                      size: 20,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      "Updates",
                      style: ThemeApp().textSemiBoldTheme(),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 33,
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Ordered\n Order Placed",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Confirmed\nWaiting for it",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Processed\nTID: #128DA",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Shipped",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Delivered",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Color(0xfff3f3f3),
                              borderRadius: BorderRadius.circular(10)),
                          width: 14,
                          child: StepProgressIndicator(
                            totalSteps: 5,
                            currentStep: 4,
                            size: 15,
                            padding: 10,
                            selectedColor: Colors.transparent,
                            unselectedColor: Color(0xfff3f3f3),
                            fallbackLength: 300,
                            roundedEdges: Radius.circular(10),
                            direction: Axis.vertical,
                            customStep: (index, color, _) =>
                                color == Colors.transparent
                                    ? Container(
                                        color: color,
                                        child: Icon(
                                          Icons.adjust_sharp,
                                          color: Colors.blue,
                                          size: 14,
                                        ),
                                      )
                                    : Container(
                                        color: color,
                                        child: Icon(
                                          Icons.adjust_sharp,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                          )),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 33,
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Kurukshetra\n 12/02/2025",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Mesci\n13/02/2025",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Austin\n14/02/2025",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Noida",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Text(
                                "Delhi",
                                style: ThemeApp().textThemeSemiGreySmall(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(14),
                  color: Color(0xfff3f3f3),
                  child: Text(
                    "Your Order will arrive on 17/02/2025",
                    style: ThemeApp().textThemeGrey(),
                  ),
                )
              ]),
            ),
          )),
    );
  }

  getPaymentInfoCard() {
    return GestureDetector(
      onTap: () {},
      child: Material(
          color: Color(0xfff3f3f3),
          // borderRadius: BorderRadius.circular(2),
          child: Card(
            margin: EdgeInsets.all(20),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    "Payment Information",
                    style: ThemeApp().heading6ThemeGrey(),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    width: double.infinity,
                    child: Text("Payment Method",
                        style: TextStyle(
                            color: Color(0xffee7625),
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.left)),
                ListTile(
                  leading: Image.asset(
                    "assets/images/visa.png",
                    height: 60,
                  ),
                  title: Text(
                    "XXXX XXXX XXXX XX36",
                    style: ThemeApp().textThemeSemiGrey(),
                  ),
                  subtitle: Text(
                    "Exp: 12/2035",
                    style: ThemeApp().textThemeSemiGrey(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Text("Billing Address",
                      style: TextStyle(
                          color: Color(0xffee7625),
                          decoration: TextDecoration.underline),
                      textAlign: TextAlign.left),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Name: Lohit Bura",
                    style: ThemeApp().textThemeGrey(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Address: Kurukshetra",
                    style: ThemeApp().textThemeGrey(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Austin, Texas, U.S.",
                    style: ThemeApp().textThemeGrey(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Pin: 100021",
                    style: ThemeApp().textThemeGrey(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "+919729018415",
                    style: ThemeApp().textThemeGrey(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "lohitbura@gmail.com",
                    style: ThemeApp().textThemeGrey(),
                  ),
                ),
              ]),
            ),
          )),
    );
  }

  getDeliveryCard() {
    return GestureDetector(
      onTap: () {},
      child: Material(
          color: Color(0xfff3f3f3),
          // borderRadius: BorderRadius.circular(2),
          child: Card(
            margin: EdgeInsets.all(20),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    "Delivery:",
                    style: ThemeApp().heading6ThemeGrey(),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: Text("Type: Basic Delivery",
                      style: TextStyle(color: Color(0xffee7625)),
                      textAlign: TextAlign.left),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Name: Lohit Bura",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Address: Kurukshetra Austin, Texas, U.S.",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Pin: 100021",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "+919729018415",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "lohitbura@gmail.com",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 15),
                  ),
                ),
              ]),
            ),
          )),
    );
  }
}
