import 'package:anne/view_model/auth_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../components/widgets/productViewColor2Card.dart';
import '../../service/event/tracking.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/api_endpoint.dart';
import '../../utility/locator.dart';
import '../../utility/query_mutation.dart';
import '../../values/event_constant.dart';
import '../../view_model/category_view_model.dart';
import '../../view_model/product_view_model.dart';
import '../../values/route_path.dart' as routes;
import 'product_list.dart';
import '../../components/widgets/loading.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPage();
  }
}

class _SearchPage extends State<SearchPage> {
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () => locator<NavigationService>().goBack(),
            child: Icon(
              Icons.arrow_back,
              color: Color(0xff525252),
            ),
          ),
          title: Container(
            margin: EdgeInsets.only(top: 5),
            child: TextField(
              // onSubmitted: ,
              controller: searchText,
              onChanged: (search) {
                setState(() {});
              },
              onSubmitted: (search) {
                locator<NavigationService>().pushNamed(routes.ProductList,
                    args: {
                      "searchKey": search,
                      "category": "",
                      "brandName": "",
                      "parentBrand":"",
                      "brand":"",
                      "urlLink":""
                    });
                // locator<NavigationService>().push(MaterialPageRoute(
                //     builder: (context) => ProductList(search, "", "")));
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "What are you looking for?",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          )),
      body: searchText.text == "" || searchText.text == null
          ? SingleChildScrollView(
              child: Column(
                children: [SearchCategoriesClass(), TopPickClass()],
              ),
            )
          : FutureBuilder(
              future: fetchAutoComplete(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('No Connectivity');
                  case ConnectionState.waiting:
                    return Loading();
                  default:
                    if (snapshot.hasError) {
                      // if error then this message is shown
                      return Center(
                          child: Text(
                        "Something Went Wrong .",
                        style: TextStyle(color: Colors.red),
                      ));
                    } else if (snapshot.data != null) {
                      //return Container();
                      return InkWell(
                          onTap: () {
                            Map<String, dynamic> data = {
                              "id": EVENT_SEARCH_SUGGESTIONS_LIST,
                              "suggestions": snapshot.data,
                              "event": "list",
                            };
                            Tracking(
                                event: EVENT_SEARCH_SUGGESTIONS_LIST,
                                data: data);
                          },
                          child: getList(snapshot.data["data"]));
                    } else
                      return Center(
                          child: Text(
                        "No Data Found ",
                        style: TextStyle(color: Colors.white),
                      ));
                }
              }),
    );
  }

  fetchAutoComplete() async {
    var response;
    Dio dio = Dio();
    response = await dio.get((ApiEndpoint()).searchHint, queryParameters: {
      // "category": categoryName.toString(),
      "q": searchText.text,
    });

    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
    } else {
      // setState(() {
      //   isLoading = false;
      // });
    }
    // }
  }

  Widget getList(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, index) {
          var item = data[index];
          print(item);
          return InkWell(
            onTap: () {
              Map<String, dynamic> data = {
                "id": EVENT_SEARCH_SUGGESTION_SELECTED,
                "itemId": "product id",
                "position": "product position in list",
                "event": "click",
              };
              Tracking(event: EVENT_SEARCH_SUGGESTION_SELECTED, data: data);
            },
            child: Column(children: [
              ListTile(
                onTap: () {
                  locator<NavigationService>().push(MaterialPageRoute(
                      builder: (context) => ProductList(item['key'], "", "","","","")));
                },
                leading: Icon(Icons.search),
                title: Text(
                  "${item['key']}",
                  maxLines: 1,
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), 0, 0,
                      ScreenUtil().setWidth(10)),
                  child: Divider())
            ]),
          );
        });
  }
}

class SearchCategoriesClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchCategoriesClass();
  }
}

class _SearchCategoriesClass extends State<SearchCategoriesClass> {
  QueryMutation addMutation = QueryMutation();

  // CategoriesResponse categoryResponse;

  @override
  Widget build(BuildContext context) {
    // ApiResponse apiResponse = Provider.of<CategoryViewModel>(context).response;
    // categoryResponse = apiResponse.data as CategoriesResponse;
    // TODO: implement build
    return Column(
      children: [
        SizedBox(
          height: ScreenUtil().setWidth(10),
        ),
        getCategoriesList()
      ],
    );
  }

  Widget getCategoriesList() {
    return Consumer<CategoryViewModel>(
      builder: (BuildContext context, value, Widget child) {
        if (value.status == "loading") {
          Provider.of<CategoryViewModel>(context, listen: false)
              .fetchCategoryData();
          if (Provider.of<ProfileModel>(context).user == null) {
            Provider.of<ProfileModel>(context, listen: false).getProfile();
          }
          return Loading();
        } else if (value.status == "empty") {
          return SizedBox.shrink();
        } else if (value.status == "error") {
          return SizedBox.shrink();
        } else {
          return Container(
            height: ScreenUtil().setWidth(140),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), 0),
            child: ListView.builder(
                itemCount: value.categoryResponse.data.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext build, index) {
                  return Container(
                      child: InkWell(
                          onTap: () {
                            locator<NavigationService>().push(MaterialPageRoute(
                                builder: (context) => ProductList(
                                    "",
                                    value.categoryResponse.data[index].slug,
                                    "","","","")));
                          },
                          child: Column(
                            children: [
                              Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(
                                              ScreenUtil().radius(40)),
                                          topRight: Radius.circular(
                                              ScreenUtil().radius(40)),
                                          bottomLeft: Radius.circular(
                                              ScreenUtil().radius(40)),
                                          topLeft: Radius.circular(
                                              ScreenUtil().radius(40)))),
                                  child: Container(
                                      width: ScreenUtil().radius(80),
                                      height: ScreenUtil().radius(80),
                                      decoration: new BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xfff3f3f3),
                                                  width: ScreenUtil().setWidth(2)),
                                              top: BorderSide(color: Color(0xfff3f3f3), width: ScreenUtil().setWidth(2)),
                                              left: BorderSide(color: Color(0xfff3f3f3), width: ScreenUtil().setWidth(2)),
                                              right: BorderSide(color: Color(0xfff3f3f3), width: ScreenUtil().setWidth(2))),
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(fit: BoxFit.cover, image: new NetworkImage(value.categoryResponse.data[index].img ?? 'https://next.anne.com/icon.png'))))),
                              SizedBox(
                                height: ScreenUtil().setWidth(15),
                              ),
                              Text(
                                value.categoryResponse.data[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(
                                      17,
                                    ),
                                    color: Color(0xff616161)),
                              ),
                            ],
                          )));
                }),
          );
        }
      },
    );
  }
}

class TopPickClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TopPickClass();
  }
}

class _TopPickClass extends State<TopPickClass> {
  QueryMutation addMutation = QueryMutation();

  // ProductResponse productResponse;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          child: getProductList(),
        )
      ],
    );
  }

  Widget getProductList() {
    return Consumer<ProductViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.trendingStatus == "loading") {
        Provider.of<ProductViewModel>(context, listen: false).fetchHotData();
        return Container();
      } else if (value.trendingStatus == "empty") {
        return SizedBox.shrink();
      } else if (value.trendingStatus == "error") {
        return SizedBox.shrink();
      }
      return Column(children: [
        SizedBox(
          height: ScreenUtil().setWidth(38),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(22),
            top: ScreenUtil().setWidth(8),
            bottom:
                3, // This can be the space you need between text and underline
          ),
          child: Text(
            "Top Picks For You",
            style: TextStyle(
                color: Color(0xff303030),
                fontSize: ScreenUtil().setSp(
                  16,
                )),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(40),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(7), 0, ScreenUtil().setWidth(7), 0),
          height: ScreenUtil().setWidth(254),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.productTrendingResponse.data.length,
              itemBuilder: (BuildContext context, index) {
                return Column(children: [
                  ProductViewColor2Card(
                      value.productTrendingResponse.data[index])
                ]);
              }),
        )
      ]);
    });
  }
}
