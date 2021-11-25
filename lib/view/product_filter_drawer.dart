import 'dart:developer';

import 'package:anne/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


typedef FilterValue = Function(List, List, List, List, String, String, String);

class ProductFilterDrawer extends StatefulWidget {
  final facet;
  final brand;
  final color;
  final size;
  final gender;
  final priceRange;
  final ageGroup;
  final discount;
  final FilterValue callback;

  ProductFilterDrawer(
      this.facet,
      this.brand,
      this.color,
      this.size,
      this.gender,
      this.priceRange,
      this.ageGroup,
      this.discount,
      this.callback);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductFilterDrawer();
  }
}

class _ProductFilterDrawer extends State<ProductFilterDrawer> {
  List brand = [];
  List color = [];
  List size = [];
  List gender = [];
  String priceRange = "";
  String ageGroup = "";
  String discount = "";
  var current = "Brand";

  @override
  void initState() {
    brand = widget.brand;
    color = widget.color;
    size = widget.size;
    gender = widget.gender;
    priceRange = widget.priceRange;
    ageGroup = widget.ageGroup;
    discount = widget.discount;
    // TODO: implement initState
    super.initState();
  }

// var screen = 1;
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
        height: ScreenUtil().setWidth(420),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color:Color(0xffdfdfdf),
                  height: ScreenUtil().setWidth(318),
                  width: ScreenUtil().setWidth(176),
                  child: Column(
                    children: [
                      _getButton("Brand"),
                      Divider(height: 0.3,color: Color(0xff616161),thickness: 0.3,),
                      _getButton("Color"),
                      Divider(height: 0.3,color: Color(0xff616161),thickness: 0.3,),
                      _getButton("Size"),
                      Divider(height: 0.3,color: Color(0xff616161),thickness: 0.3,),
                      _getButton("Gender"),
                      Divider(height: 0.3,color: Color(0xff616161),thickness: 0.3,),
                      _getButton("Price Range"),
                      Divider(height: 0.3,color: Color(0xff616161),thickness: 0.3,),
                      _getButton("Age Group"),
                      Divider(height: 0.3,color: Color(0xff616161),thickness: 0.3,),
                      _getButton("Discount"),
                      Divider(height: 0.3,color: Color(0xff616161),thickness: 0.3,),
                    ],
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(238),
                  height: ScreenUtil().setWidth(318),
                  child: getSecondColumn() ,
                )
              ],
            ),
            Container(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        width: ScreenUtil().setWidth(206),
                        height: ScreenUtil().setWidth(45),
                        color: Color(0xffffffff),
                        child: Center(
                            child: Text(
                              "CLOSE",
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(16)),
                            ))),
                  ),
                  InkWell(
                    onTap: () {

                      widget.callback(brand, color, size, gender, priceRange,
                          ageGroup, discount);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        width: ScreenUtil().setWidth(206),
                        height: ScreenUtil().setWidth(45),
                        color: AppColors.primaryElement,
                        child: Center(
                            child: Text("APPLY",
                                style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: ScreenUtil().setSp(16))))),
                  ),
                ],
              ),
            )
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
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(15),right: ScreenUtil().setWidth(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(child: Text(
                    "FILTER BY",
                    style: TextStyle(
                        color: Color(0xff616161),
                        fontSize: ScreenUtil().setSp(16)),
                  ),),
                  InkWell(
                    onTap: () {
                      brand = [];
                      color = [];
                      size = [];
                      gender = [];
                      priceRange = "";
                      ageGroup = "";
                      discount = "";
                      widget.callback(brand, color, size, gender, priceRange,
                          ageGroup, discount);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Clear All",
                      style: TextStyle(
                          color: AppColors.primaryElement,
                          fontSize: ScreenUtil().setSp(12)),
                    ),
                  )
                ],
              )),
        ));
  }

  brandFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        itemCount: widget.facet["all_aggs"]["brands"]["all"]["buckets"].length,
        itemBuilder: (BuildContext context, index) {
          var item =
          widget.facet["all_aggs"]["brands"]["all"]["buckets"][index];

          return item['doc_count']>0? Container(
              height: ScreenUtil().setWidth(50),
              child: ListTile(
                onTap: () {

                  if (brand.contains(item["key"])) {
                    setState(() {
                      brand.remove(item["key"]);
                    });
                  } else {
                    setState(() {
                      brand.add(item["key"]);
                    });
                  }
                },
                trailing: brand.contains(item["key"])
                    ? Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryElement,
                )
                    : Icon(
                  Icons.radio_button_unchecked,
                  color: Color(0xff4a4a4a),
                ),
                title: brand.contains(item["key"])
                    ? Text(
                  "${item['key']}",
                  style: TextStyle(
                      color: AppColors.primaryElement,
                      fontSize: ScreenUtil().setWidth(14)),
                )
                    : Text("${item['key']}",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontSize: ScreenUtil().setWidth(14))),
              )):Container();
        });
  }

  colorFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        itemCount: widget.facet["all_aggs"]["colors"]["all"]["buckets"].length,
        itemBuilder: (BuildContext context, index) {
          var item =
          widget.facet["all_aggs"]["colors"]["all"]["buckets"][index];

          return item['doc_count']>0? Container(
              height: ScreenUtil().setWidth(50),
              child: ListTile(
                onTap: () {

                  if (color.contains(item["key"])) {
                    setState(() {
                      color.remove(item["key"]);
                    });
                  } else {
                    setState(() {
                      color.add(item["key"]);
                    });
                  }
                },
                trailing: color.contains(item["key"])
                    ? Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryElement,
                )
                    : Icon(
                  Icons.radio_button_unchecked,
                  color: Color(0xff4a4a4a),
                ),
                title: color.contains(item["key"])
                    ? Text(
                  "${item['key']}",
                  style: TextStyle(
                      color: AppColors.primaryElement,
                      fontSize: ScreenUtil().setWidth(14)),
                )
                    : Text("${item['key']}",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontSize: ScreenUtil().setWidth(14))),
              )):Container();
        });
  }

  sizeFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        itemCount: widget.facet["all_aggs"]["sizes"]["all"]["buckets"].length,
        itemBuilder: (BuildContext context, index) {
          var item = widget.facet["all_aggs"]["sizes"]["all"]["buckets"][index];
          log(item.toString());
          return item['doc_count']>0? Container(
              height: ScreenUtil().setWidth(50),
              child: ListTile(
                onTap: () {

                  if (size.contains(item["key"])) {
                    setState(() {
                      size.remove(item["key"]);
                    });
                  } else {
                    setState(() {
                      size.add(item["key"]);
                    });
                  }
                },
                trailing: size.contains(item["key"])
                    ? Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryElement,
                )
                    : Icon(
                  Icons.radio_button_unchecked,
                  color: Color(0xff4a4a4a),
                ),
                title: size.contains(item["key"])
                    ? Text(
                  "${item['key']}",
                  style: TextStyle(
                      color: AppColors.primaryElement,
                      fontSize: ScreenUtil().setWidth(14)),
                )
                    : Text("${item['key']}",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontSize: ScreenUtil().setWidth(14))),
              )):Container();
        });
  }

  _getButton(String s) {
    return InkWell(
        onTap: () {
          setState(() {
            current = s;
          });
        },
        child: Container(
          color: s == current ? Color(0xffffffff) : Color(0xffdfdfdf),
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(26), top: ScreenUtil().setWidth(15)),
          height: ScreenUtil().setWidth(45),
          width: ScreenUtil().setWidth(176),
          child: Text(
            s,
            style: TextStyle(
                color: s == current ? Color(0xff4a4a4a) : Color(0xff616161),
                fontSize: ScreenUtil().setSp(16)),
          ),
        ));
  }

  getSecondColumn() {
    if (current == "Brand") {
      return Container(
        height: ScreenUtil().setWidth(412),
        child:  brandFetch(),
      );
    }
    else if (current == "Color") {
      return Container(
        height: ScreenUtil().setWidth(412),
        child: colorFetch(),
      );
    }
    else if (current == "Size") {
      return Container(
        height: ScreenUtil().setWidth(412),
        child: sizeFetch(),
      );
    }

    else if (current == "Gender") {
      return Container(
        height: ScreenUtil().setWidth(412),
        child: genderFetch(),
      );
    }

    else if (current == "Price Range") {
      return Container(
        height: ScreenUtil().setWidth(412),
        child: priceRangeFetch(),
      );
    }

    else if (current == "Age Group") {
      return Container(
        height: ScreenUtil().setWidth(412),
        child: ageGroupFetch(),
      );
    }

    else if (current == "Discount") {
      return Container(
        height: ScreenUtil().setWidth(412),
        child: discountFetch(),
      );
    }

    else return Container();
  }

  genderFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        itemCount: widget.facet["all_aggs"]["genders"]["all"]["buckets"].length,
        itemBuilder: (BuildContext context, index) {
          var item =
          widget.facet["all_aggs"]["genders"]["all"]["buckets"][index];
          log(item.toString());
          return item['doc_count']>0? Container(
              height: ScreenUtil().setWidth(50),
              child: ListTile(
                onTap: () {

                  if (gender.contains(item["key"])) {
                    setState(() {
                      gender.remove(item["key"]);
                    });
                  } else {
                    setState(() {
                      gender.add(item["key"]);
                    });
                  }
                },
                trailing: gender.contains(item["key"])
                    ? Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryElement,
                )
                    : Icon(
                  Icons.radio_button_unchecked,
                  color: Color(0xff4a4a4a),
                ),
                title: gender.contains(item["key"])
                    ? Text(
                  "${item['key']}",
                  style: TextStyle(
                      color: AppColors.primaryElement,
                      fontSize: ScreenUtil().setWidth(14)),
                )
                    : Text("${item['key']}",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontSize: ScreenUtil().setWidth(14))),
              )):Container();
        });
  }

  priceRangeFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        itemCount: widget.facet["all_aggs"]["price"]["all"]["buckets"].length,
        itemBuilder: (BuildContext context, index) {
          var item = widget.facet["all_aggs"]["price"]["all"]["buckets"][index];
          log(item.toString());
          return item['doc_count']>0? Container(
              height: ScreenUtil().setWidth(50),
              child: ListTile(
                onTap: () {

                  if (priceRange == item["from"].toString()+","+item["to"].toString()) {

                  } else {
                    setState(() {
                      priceRange = item["from"].toString()+","+item["to"].toString();
                    });
                  }
                },
                trailing: priceRange==item["from"].toString()+","+item["to"].toString()
                    ? Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryElement,
                )
                    : Icon(
                  Icons.radio_button_unchecked,
                  color: Color(0xff4a4a4a),
                ),
                title: priceRange==item["value"]
                    ? Text(
                  "${item['key']}",
                  style: TextStyle(
                      color: AppColors.primaryElement,
                      fontSize: ScreenUtil().setWidth(14)),
                )
                    : Text("${item['key']}",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontSize: ScreenUtil().setWidth(14))),
              )):Container();
        });
  }

  ageGroupFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        itemCount: widget.facet["all_aggs"]["age"]["all"]["buckets"].length,
        itemBuilder: (BuildContext context, index) {
          var item = widget.facet["all_aggs"]["age"]["all"]["buckets"][index];

          return item['doc_count']>0? Container(
              height: ScreenUtil().setWidth(50),
              child: ListTile(
                onTap: () {

                  if (ageGroup==item["key"]) {
                    // setState(() {
                    //   ageGroup.remove(item["key"]);
                    // });
                  } else {
                    setState(() {
                      ageGroup=item["from"].toString()+","+item["to"].toString();
                    });
                  }
                },
                trailing: ageGroup==item["from"].toString()+","+item["to"].toString()
                    ? Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryElement,
                )
                    : Icon(
                  Icons.radio_button_unchecked,
                  color: Color(0xff4a4a4a),
                ),
                title: ageGroup==item["from"].toString()+","+item["to"].toString()
                    ? Text(
                  "${item['key']}",
                  style: TextStyle(
                      color: AppColors.primaryElement,
                      fontSize: ScreenUtil().setWidth(14)),
                )
                    : Text("${item['key']}",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontSize: ScreenUtil().setWidth(14))),
              )):Container();
        });
  }

  discountFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return Container(
        height: ScreenUtil().setWidth(50),
        child: ListView.builder(
            padding: EdgeInsets.only(top: 0, bottom: 0),
            itemCount:
            widget.facet["all_aggs"]["discount"]["all"]["buckets"].length,
            itemBuilder: (BuildContext context, index) {
              var item =
              widget.facet["all_aggs"]["discount"]["all"]["buckets"][index];

              return item['doc_count']>0? ListTile(
                onTap: () {

                  if (discount==item["from"].toString()+","+item["to"].toString()) {
                    // setState(() {
                    //   discount.remove(item["key"]);
                    // });
                  } else {
                    setState(() {
                      discount = item["from"].toString()+","+item["to"].toString();
                    });
                  }
                },
                trailing: discount==item["from"].toString()+","+item["to"].toString()
                    ? Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryElement,
                )
                    : Icon(
                  Icons.radio_button_unchecked,
                  color: Color(0xff4a4a4a),
                ),
                title: discount==item["key"]
                    ? Text(
                  "${item['key']}",
                  style: TextStyle(
                      color: AppColors.primaryElement,
                      fontSize: ScreenUtil().setWidth(14)),
                )
                    : Text("${item['key']}",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontSize: ScreenUtil().setWidth(14))),
              ):Container();
            }));
  }
}
