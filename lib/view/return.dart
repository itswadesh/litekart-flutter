import 'dart:async';

import 'package:anne/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../components/base/tz_dialog.dart';
import '../../enum/tz_dialog_type.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../utility/query_mutation.dart';
import '../../view_model/manage_order_view_model.dart';
import '../../values/route_path.dart' as routes;
import '../utility/graphQl.dart';
import '../utility/theme.dart';
import 'cart_logo.dart';

class ReturnPage extends StatefulWidget {
  final id;
  final pid;
  final qty;
  ReturnPage(this.id,this.pid,this.qty);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReturnPage();
  }
}

class _ReturnPage extends State<ReturnPage> {
  var currentStep = 2;
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  String reason = "";
  List reasonList = ["Product Not Required Anymore","Cash Issue","Ordered By Mistake","Want to Change the product","Delay Delivery cancellation","I have changed my mind","Want to change order delivery details","Others"];
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
            size: ScreenUtil().setWidth(28)
          ),
        ),
        title: Center(
            // width: MediaQuery.of(context).size.width * 0.39,
            child: Text(
          "Return",
          style: TextStyle(
              color: Color(0xff616161),
              fontSize: ScreenUtil().setSp(
                21,
              )),
          textAlign: TextAlign.center,
        )),
        actions: [
          Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
              // width: MediaQuery.of(context).size.width * 0.35,
              child: CartLogo(25))
        ],
      ),
      body: GraphQLProvider(
          client: graphQLConfiguration.initailizeClient(),
          child: CacheProvider(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Color(0xfff3f3f3),
                  child: getData()
                  ))),
    );
  }

  getData() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setWidth(35),
            ),
           //  Container(
           //      child: Text(
           //    "${reason==""?"REASON FOR RETURN":"CONFIRM RETURN"}",
           //    style: TextStyle(color: Color(0xff616161), fontSize: ScreenUtil().setSp(17),fontWeight: FontWeight.w600),
           //  )),
           //  SizedBox(
           //    height: ScreenUtil().setWidth(35),
           //  ),
           // progressCard(),
           //  SizedBox(
           //    height: ScreenUtil().setWidth(10),
           //  ),
            Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(19), 0, ScreenUtil().setWidth(27), ScreenUtil().setWidth(26)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "${reason==""?"Select Reason for return":"Confirm Return"}",
                      style: TextStyle(
                        color:Color(0xff616161),
                        fontSize: ScreenUtil().setWidth(14),
                      ),
                    ),
                  ),
                  Container(
                    child: Text("Returning item (1)",
                        style: TextStyle(color: Color(0xff616161), fontSize: ScreenUtil().setWidth(14),)),
                  )
                ],
              ),
            ),
           reason==""? getReasonList():getConfirmWidget()
          ],
        ),
      ),
    );
  }

  progressCard() {
    return Container(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), ScreenUtil().setWidth(10)),
        child: Container(
          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setWidth(20), ScreenUtil().setWidth(10), ScreenUtil().setWidth(10)),
          child: Column(
            children: [
              stepIndicator(),
              SizedBox(
                height: ScreenUtil().setWidth(32),
              ),
              Container(
                  child: Text(
                "Return you product within 15 days after purchasing",
                style: ThemeApp().textThemeGrey(),
              )),
              SizedBox(
                height: ScreenUtil().setWidth(32),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Container(
              //       child: Text(
              //         "Print return Invoice",
              //         style: TextStyle(color: Colors.blue, fontSize: 13),
              //       ),
              //     ),
              //     Icon(
              //       Icons.print,
              //       color: Colors.blue,
              //       size: 18,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  stepIndicator() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(9.5), ScreenUtil().setWidth(5), ScreenUtil().setWidth(9.5), ScreenUtil().setWidth(5)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xffc53193), width: 2),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))),
            child: Text(
              "1",
              style: TextStyle(color: Color(0xffc53193)),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              color: currentStep > 1 ? Color(0xffc53193) : Color(0xfff3f3f3),
            ),
            height: ScreenUtil().setWidth(10),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(8.5), ScreenUtil().setWidth(5), ScreenUtil().setWidth(8.5), ScreenUtil().setWidth(5)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xffc53193), width: 2),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))),
            child: Text(
              "2",
              style: TextStyle(color: Color(0xffc53193)),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              color: currentStep > 2 ? Color(0xffc53193) : Color(0xfff3f3f3),
            ),
            height: ScreenUtil().setWidth(10),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(8.2), ScreenUtil().setWidth(5), ScreenUtil().setWidth(8.2), ScreenUtil().setWidth(5)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xffc53193), width: 2),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))),
            child: Text(
              "3",
              style: TextStyle(color: Color(0xffc53193)),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              color: currentStep > 3 ? Color(0xffc53193) : Color(0xfff3f3f3),
            ),
            height: ScreenUtil().setWidth(10),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(7.9), ScreenUtil().setWidth(5), ScreenUtil().setWidth(7.9), ScreenUtil().setWidth(5)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xffc53193), width: 2),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))),
            child: Text(
              "4",
              style: TextStyle(color: Color(0xffc53193)),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
                color: currentStep > 4 ? Color(0xffc53193) : Color(0xfff3f3f3),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(ScreenUtil().setWidth(10)),
                    bottomRight: Radius.circular(ScreenUtil().setWidth(10)))),
            height: ScreenUtil().setWidth(10),
          )
        ],
      ),
    );
  }

  getProductList() {
    return Container();
  }

  getReasonList() {
    return Material(
      // color: Color(0xffe5e5e5),
      // borderRadius: BorderRadius.circular(2),
        child: Card(

            // shape:Border(
            //
            //     top: BorderSide(color: Color(0xff00d832,)),
            //     bottom: BorderSide(color: AppColors.primaryElement2),
            //     left: BorderSide(color: AppColors.primaryElement2),
            //     right: BorderSide(color: AppColors.primaryElement2)
            // ),
            margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(21), 0,
                ScreenUtil().setWidth(22), ScreenUtil().setWidth(12)),
            elevation: 0,
            child: Container(
        //     padding: EdgeInsets.fromLTRB(
        //     ScreenUtil().setWidth(24),
        // ScreenUtil().setWidth(23),
        // ScreenUtil().setWidth(19),
        // ScreenUtil().setWidth(24)),
    decoration: BoxDecoration(
    color: Colors.white,
    ),
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reasonList.length,
        itemBuilder: (BuildContext context, index){
      return ListTile(
        onTap: (){
          setState(() {
            currentStep = 3;
            reason = reasonList[index];
          });
        },
        leading: Icon(Icons.radio_button_off,color: Color(0xff707070),size: ScreenUtil().setWidth(25),),
        title: Text(reasonList[index],style: TextStyle(
          color: Color(0xff616161),
          fontSize: ScreenUtil().setWidth(15),
        ),),
      );
    }))));
  }

  getConfirmWidget() {
    return Material(
      // color: Color(0xffe5e5e5),
      // borderRadius: BorderRadius.circular(2),
      child: Card(

          shape:Border(

              top: BorderSide(color: AppColors.primaryElement2),
              bottom: BorderSide(color: AppColors.primaryElement2),
              left: BorderSide(color: AppColors.primaryElement2),
              right: BorderSide(color: AppColors.primaryElement2)
          ),
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
                    SizedBox(height: ScreenUtil().setWidth(72),),
                    Container(child: Text("Are you sure you want to Return this Product",
                    style: TextStyle(color: Color(0xff616161),
                    fontSize: ScreenUtil().setWidth(15)),),),
                    SizedBox(height: ScreenUtil().setWidth(39),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: ScreenUtil().setWidth(44),
                          width: ScreenUtil().setWidth(158),
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(
                                0,
                                ScreenUtil().setWidth(14),
                                0,
                                ScreenUtil().setWidth(13)),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(5)),
                            ),
                            textColor: Colors.white,
                            color: AppColors.primaryElement,
                            onPressed: () {
                                locator<NavigationService>().pop();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    15,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Container(
                          height: ScreenUtil().setWidth(44),
                          width: ScreenUtil().setWidth(158),
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(0),
                                ScreenUtil().setWidth(14),
                                0,
                                ScreenUtil().setWidth(13)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(5)),
                                side: BorderSide(color: AppColors.primaryElement2)),
                            color: Colors.white,
                            textColor: AppColors.primaryElement2,
                            onPressed: () async {
                              TzDialog _dialog = TzDialog(context, TzDialogType.progress);
                              _dialog.show();
                             bool result =  await OrderViewModel().returnItem(widget.id, widget.pid, reason, "Return", widget.qty);
                              _dialog.close();
                              setState(() {
                                currentStep = 5;
                              });
                             if(result){
                                confirmPopup();
                              }
                             },
                            child: Text(
                              "Return this Product",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    15,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setWidth(61),)
                  ]),
            ),
          )),
    );
  }

  void confirmPopup() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          Timer(Duration(seconds: 3),
              onDoneLoading);
          return AlertDialog(
            content:  Container(
                    height: ScreenUtil().setWidth(228),
                    width: ScreenUtil().setWidth(391),
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil().setWidth(33),),
                        Container(
                          padding:
                          EdgeInsets.all(ScreenUtil().setWidth(12)),
                          width: ScreenUtil().setWidth(82),
                          height: ScreenUtil().setWidth(82),
                          decoration: BoxDecoration(
                              color: Color(0xff85ffa1),
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(45))),
                          child: Container(
                            width: ScreenUtil().setWidth(55),
                            height: ScreenUtil().setWidth(55),
                            decoration: BoxDecoration(
                                color: AppColors.primaryElement2,
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(40))),
                            child: Icon(
                              Icons.check,
                              size: ScreenUtil().setWidth(40),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(33),),
                        Container(
                          child: Text("Item Returned Successfully",style: TextStyle(color:AppColors.primaryElement2,fontSize: ScreenUtil().setWidth(19)),),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(23),),
                        Container(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(5),right: ScreenUtil().setWidth(5)),
                          child: Text("We Will Pickup your parcel soon from your location",style: TextStyle(color:Color(0xff616161
                          ),fontSize: ScreenUtil().setWidth(13)),textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
            ));});
  }

  onDoneLoading(){
    locator<NavigationService>().pushNamedAndRemoveUntil(routes.HomeRoute);
  }
}
