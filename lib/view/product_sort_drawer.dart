import 'package:anne/values/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../service/event/tracking.dart';
import '../../values/event_constant.dart';

typedef SortValue = Function(String?);

class ProductSortDrawer extends StatefulWidget {
  final sort;
  final SortValue callback;

  ProductSortDrawer(
      this.sort,
      this.callback);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductSortDrawer();
  }
}

class _ProductSortDrawer extends State<ProductSortDrawer> {

  var sort ;
  var sorts = [
    { "name": 'Relevance', "val": "" },
    { "name": 'Whats New', "val": '-createdAt' },
    { "name": 'Price low to high', "val": 'price' },
    { "name": 'Price high to low', "val": '-price' },
  ];
  @override
  void initState() {
   sort = widget.sort;
    // TODO: implement initState
    super.initState();
  }

// var screen = 1;
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
        height: ScreenUtil().setWidth(265),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(25)),
              topRight: Radius.circular(ScreenUtil().setWidth(25)),
            )),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setWidth(25)),
                    topRight: Radius.circular(ScreenUtil().setWidth(25)),
                  )),
              child: _createHeader(),
            ),
            Container(
              height: ScreenUtil().setWidth(209),
              width: ScreenUtil().setWidth(386),
              child: Column(
                children: [
                  Divider(
                    height: ScreenUtil().setWidth(0.4),
                    thickness: ScreenUtil().setWidth(0.4),
                    color: Color(0xff707070),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(20),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                    height: ScreenUtil().setWidth(180),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                        itemCount: sorts.length,
                        itemBuilder: (BuildContext build, index) {
                          return InkWell(
                            onTap: (){
                                            sort = sorts[index]["val"];
                                            widget.callback(sort);
                                            Navigator.of(context).pop();
                            },
                            child: Container(
                                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(25)),
                                child: Text(
                                                  sorts[index]["name"]!,
                                                  style: TextStyle(
                                                      color: (sorts[index]["val"] == sort)
                                              ?Color(0xff000000):Color(0xff656565),
                                                      fontSize:
                                                      ScreenUtil().setSp(
                                                        17,
                                                      ),
                                                    fontWeight:  (sorts[index]["val"] == sort)
                                                        ?FontWeight.w600:FontWeight.normal
                          ),
                            ))

                          );
                        }),
                  ),

                ],
              ),
            ),

          ],
        ));
  }

  Widget _createHeader() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(25)),
              topRight: Radius.circular(ScreenUtil().setWidth(25)),
            )),
        height: ScreenUtil().setWidth(56),
        child: Center(
          child: Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                    },
                    child: Text(
                      "SORT BY",
                      style: TextStyle(
                          color: Color(0xff616161),
                          fontSize: ScreenUtil().setSp(16)),
                    ),
                  )
                ],
              )),
        ));
  }


}
