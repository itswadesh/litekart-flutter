//import 'package:anne/components/widgets/productViewColorCard.dart';

import 'package:anne/view_model/list_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class ListDealsClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListDealsClass();
  }
}

class _ListDealsClass extends State<ListDealsClass> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [getDealsList()],
    );
  }

  Widget getDealsList() {
    return Consumer<ListDealsViewModel>(
        builder: (BuildContext context, value, Widget? child) {
          if (value.status == "loading") {
            Provider.of<ListDealsViewModel>(context, listen: false)
                .fetchDealsData();
            return Container();
          } else if (value.status == "empty") {
            return SizedBox.shrink();
          } else if (value.status == "error") {
            return SizedBox.shrink();
          } else {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/dealListBackground.gif"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenUtil().setWidth(20),
                  ),
                  Text(
                    "Deals of",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(
                          44,
                        )),
                  ),
                  Text(
                    "the Week",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(
                          44,
                        )),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(32),
                  ),
                  Text("Sales are expiring in",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(
                            16,
                          ))),
                  SizedBox(
                    height: ScreenUtil().setWidth(19),
                  ),
                  Container(
                    child: CountdownTimer(
                      endTime:
                      int.parse(value.listDealsResponse!.data![0].endTimeISO!),
                      widgetBuilder: (_, CurrentRemainingTime? time) {
                        if (time == null) {
                          return Text('Ended');
                        }
                        return Container(
                          height: ScreenUtil().setWidth(44),
                          width: ScreenUtil().setWidth(241),
                          color: Colors.grey,
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(6),
                              ScreenUtil().setWidth(7),
                              ScreenUtil().setWidth(6),
                              ScreenUtil().setWidth(7)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: ScreenUtil().setWidth(31),
                                  width: ScreenUtil().setWidth(31),
                                  // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                  child: Center(
                                      child: Text(
                                          "${(time.hours != null ? time.hours : 0)! ~/ 10}",
                                          style: TextStyle(color: Colors.black38))),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                  )),
                              SizedBox(
                                width: ScreenUtil().setWidth(4),
                              ),
                              Container(
                                  height: 31,
                                  width: 31,
                                  // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                  child: Center(
                                      child: Text(
                                          "${(time.hours != null ? time.hours : 0)! % 10}",
                                          style: TextStyle(color: Colors.black38))),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(3),
                                      right: ScreenUtil().setWidth(3)),
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        ),
                                        fontWeight: FontWeight.w600),
                                  )),
                              Container(
                                  height: ScreenUtil().setWidth(31),
                                  width: ScreenUtil().setWidth(31),
                                  // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                  child: Center(
                                      child: Text(
                                          "${(time.min != null ? time.min : 0)! ~/ 10}",
                                          style: TextStyle(color: Colors.black38))),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                  )),
                              SizedBox(
                                width: ScreenUtil().setWidth(4),
                              ),
                              Container(
                                  height: ScreenUtil().setWidth(31),
                                  width: ScreenUtil().setWidth(31),
                                  // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                  child: Center(
                                      child: Text(
                                          "${(time.min != null ? time.min : 0)! % 10}",
                                          style: TextStyle(color: Colors.black38))),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(3),
                                      right: ScreenUtil().setWidth(3)),
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        ),
                                        fontWeight: FontWeight.w600),
                                  )),
                              Container(
                                  height: ScreenUtil().setWidth(31),
                                  width: ScreenUtil().setWidth(31),
                                  // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                  child: Center(
                                      child: Text(
                                          "${(time.sec != null ? time.sec : 0)! ~/ 10}",
                                          style: TextStyle(color: Colors.black38))),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                  )),
                              SizedBox(
                                width: ScreenUtil().setWidth(4),
                              ),
                              Container(
                                  height: ScreenUtil().setWidth(31),
                                  width: ScreenUtil().setWidth(31),
                                  // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                  child: Center(
                                      child: Text(
                                          "${(time.sec != null ? time.sec : 0)! % 10}",
                                          style: TextStyle(color: Colors.black38))),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                  )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(48),
                  ),
              //    Container(
              //      padding:
              //      EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), 0, 0, 0),
              //      height: ScreenUtil().setWidth(254),
              //      child: ListView.builder(
              //          scrollDirection: Axis.horizontal,
              //          itemCount: value.listDealsResponse!.data![0].products!.length,
              //          itemBuilder: (BuildContext context, index) {
              //            return ProductViewColorCard(
              //                value.listDealsResponse!.data![0].products![index]);
              //          }),
               //   ),
                  SizedBox(
                    height: ScreenUtil().setWidth(40),
                  )
                ],
              ),
            );
          }
        });
  }
}
