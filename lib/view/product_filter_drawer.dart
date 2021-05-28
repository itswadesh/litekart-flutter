import 'package:flutter/material.dart';
import '../utility/theme.dart';

typedef filterValue = Function(List, List, List);

class ProductFilterDrawer extends StatefulWidget {
  final facet;
  final brand;
  final color;
  final size;
  final filterValue callback;

  ProductFilterDrawer(
      this.facet, this.brand, this.color, this.size, this.callback);

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

  var current = "Brand";

  @override
  void initState() {
    brand = widget.brand;
    color = widget.color;
    size = widget.color;
    // TODO: implement initState
    super.initState();
  }

// var screen = 1;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.33,
                child: Column(
                  children: [
                    _getButton("Brand"),
                    _getButton("Color"),
                    _getButton("Size"),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.height * 0.7,
                child: getSecondColumn(),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
              onPressed: () {
                widget.callback(brand, color, size);
                Navigator.of(context).pop();
              },
              color: Color(0xffe6b05b),
              child: Text(
                "Save",
                style: ThemeApp().buttonTextTheme(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return Container(
      child: Column(children: [
        SizedBox(
          height: 40,
        ),
        ListTile(
            title: Text(
              "Filter By",
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff774f20),
                  fontFamily: 'Montserrat'),
            ),
            trailing: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close),
            ))
      ]),
    );
  }

  brandFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return ListView.builder(
        itemCount: widget.facet["all_aggs"]["brands"]["all"]["buckets"].length,
        itemBuilder: (BuildContext context, index) {
          var item =
              widget.facet["all_aggs"]["brands"]["all"]["buckets"][index];
          print(item);
          return ListTile(
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
            leading: brand.contains(item["key"])
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank),
            title: Text("${item['key']}"),
          );
        });
  }

  colorFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return ListView.builder(
        itemCount: widget.facet["all_aggs"]["colors"]["all"]["buckets"].length,
        itemBuilder: (BuildContext context, index) {
          var item =
              widget.facet["all_aggs"]["colors"]["all"]["buckets"][index];
          print(item);
          return ListTile(
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
            leading: color.contains(item["key"])
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank),
            title: Text("${item['key']}"),
          );
        });
  }

  sizeFetch() {
    //final TabController tabController = DefaultTabController.of(context);

    //TextEditingController _brand = TextEditingController();
    return ListView.builder(
        itemCount: widget.facet["all_aggs"]["sizes"]["all"]["buckets"].length,
        itemBuilder: (BuildContext context, index) {
          var item = widget.facet["all_aggs"]["sizes"]["all"]["buckets"][index];
          print(item);
          return ListTile(
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
            leading: size.contains(item["key"])
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank),
            title: Text("${item['key']}"),
          );
        });
  }

  _getButton(String s) {
    return Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        width: MediaQuery.of(context).size.width * 0.3,
        child: RaisedButton(
          onPressed: () {
            setState(() {
              current = s;
            });
          },
          color: s == current ? Color(0xff774f20) : Colors.grey.shade300,
          child: Text(
            s,
            style: ThemeApp().buttonTextTheme(),
          ),
        ));
  }

  getSecondColumn() {
    if (current == "Brand") {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: brandFetch(),
      );
    }
    if (current == "Color") {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: colorFetch(),
      );
    }
    if (current == "Size") {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: sizeFetch(),
      );
    }

    return Container();
  }
}
