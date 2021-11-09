import 'package:anne/components/widgets/productCard.dart';
import 'package:anne/utility/theme.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/view_model/settings_view_model.dart';
import 'package:anne/view_model/store_view_model.dart';
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
import '../main.dart';
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

  FocusNode? _focusNode;
  bool showSuggestion = false;
  @override
  void initState() {
    _focusNode = FocusNode();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    super.initState();
  }

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
              focusNode: _focusNode,
              // onSubmitted: ,
              controller: searchText,
              onChanged: (search) {
                setState(() {
                  if(searchText.text == "" || searchText.text == null){
                    showSuggestion = false;
                  }
                  else{
                    showSuggestion  = true;
                  }
                });
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
      body: !showSuggestion
          ? SingleChildScrollView(
              child: Column(
                children: [SizedBox(height: ScreenUtil().setWidth(15),),SearchCategoriesClass(), TopPickClass()],
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
                      showSuggestion = false;
                      return SingleChildScrollView(
                        child: Column(
                          children: [SizedBox(height: ScreenUtil().setWidth(15),),SearchCategoriesClass(), TopPickClass()],
                        ),
                      );
                    } else if (snapshot.data != null && snapshot.data["data"]!=null && snapshot.data["data"].length!=0) {
                      return InkWell(
                          onTap: () {
                            // Map<String, dynamic> data = {
                            //   "id": EVENT_SEARCH_SUGGESTIONS_LIST,
                            //   "suggestions": snapshot.data,
                            //   "event": "list",
                            // };
                            // Tracking(
                            //     event: EVENT_SEARCH_SUGGESTIONS_LIST,
                            //     data: data);
                          },
                          child: getList(snapshot.data["data"]));
                    } else {
                      showSuggestion = false;
                      return SingleChildScrollView(
                        child: Column(
                          children: [SizedBox(height: ScreenUtil().setWidth(15),),SearchCategoriesClass(), TopPickClass()],
                        ),
                      );
                    }
                }
              }),
    );
  }

  fetchAutoComplete() async {
    var response;
    Dio dio = Dio();
    response = await dio.get((ApiEndpoint()).searchHint!, queryParameters: {
      // "category": categoryName.toString(),
      "q": searchText.text,
      "store": store!.id
    });

    if (response.statusCode == 200) {

      return response.data;
    } else {
      showSuggestion = false;
      return null;
      // setState(() {
      //   isLoading = false;
      // });
    }
    // }
  }

  Widget getList(data) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
        itemCount: data.length,
        itemBuilder: (BuildContext context, index) {
          var item = data[index];

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
                  locator<NavigationService>().pushNamed(routes.ProductList,args: {
                    "searchKey":item['key'],
                    "category":"",
                    "brandName":"",
                    "parentBrand":"",
                    "brand":"",
                    "urlLink":""
                  });
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
        // SizedBox(
        //   height: ScreenUtil().setWidth(10),
        // ),
        getCategoriesList()
      ],
    );
  }

  Widget getCategoriesList() {
    return Consumer<CategoryViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        if (value.status == "loading") {
          Provider.of<CategoryViewModel>(context, listen: false)
              .fetchCategoryData();
          if (Provider.of<ProfileModel>(context).user == null) {
            Provider.of<ProfileModel>(context, listen: false).getProfile();
          }
          if(Provider.of<StoreViewModel>(context).status=="loading"||Provider.of<StoreViewModel>(context).status=="error"){ Provider.of<StoreViewModel>(context,
              listen: false)
              .fetchStore();
          }
         if(Provider.of<SettingViewModel>(context).status=="loading"||Provider.of<SettingViewModel>(context).status=="error"){ Provider.of<SettingViewModel>(context,
              listen: false)
              .fetchSettings();
         }

          return Container();
        } else if (value.status == "empty") {
          if(Provider.of<StoreViewModel>(context).status=="loading"||Provider.of<StoreViewModel>(context).status=="error"){ Provider.of<StoreViewModel>(context,
              listen: false)
              .fetchStore();
          }
          return SizedBox.shrink();
        } else if (value.status == "error") {
          if(Provider.of<StoreViewModel>(context).status=="loading"||Provider.of<StoreViewModel>(context).status=="error"){ Provider.of<StoreViewModel>(context,
              listen: false)
              .fetchStore();
          }
          return SizedBox.shrink();

        } else {
          if(Provider.of<StoreViewModel>(context).status=="loading"||Provider.of<StoreViewModel>(context).status=="error"){ Provider.of<StoreViewModel>(context,
              listen: false)
              .fetchStore();
          }
          return Container(
            height: ScreenUtil().setWidth(135),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(10), ScreenUtil().setWidth(10), ScreenUtil().setWidth(10), 0),
            child: ListView.builder(
                itemCount: value.categoryResponse!.data!.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext build, index) {
                  return (value.categoryResponse!.data![index].img!=null && value.categoryResponse!.data![index].img!="" )? Container(
                    width: ScreenUtil().setWidth(100),
                      child: InkWell(
                          onTap: () {
                            locator<NavigationService>().pushNamed(routes.ProductList,args: {
                              "searchKey":"",
                              "category":value.categoryResponse!.data![index].slug,
                              "brandName":"",
                              "parentBrand":"",
                              "brand":"",
                              "urlLink":""
                            });
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
                                          image: new DecorationImage(fit: BoxFit.cover, image: ((value.categoryResponse!.data![index].img!=null && value.categoryResponse!.data![index].img!="" )? NetworkImage(value.categoryResponse!.data![index].img!+"?tr=h-80,w-80,fo-auto"):AssetImage("assets/images/logo.png")) as ImageProvider<Object>)))),
                              SizedBox(
                                height: ScreenUtil().setWidth(5),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(100),
                                child:
                              Text(
                                value.categoryResponse!.data![index].name!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(
                                      17,
                                    ),

                                    color: Color(0xff616161)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              )
                            ],
                          ))):Container();
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
        builder: (BuildContext context, value, Widget? child) {
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
          height: ScreenUtil().setWidth(8),
        ),
        Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
          width: double.infinity,
          // padding: EdgeInsets.only(
          //   bottom: ScreenUtil().setWidth(
          //       7.5), // This can be the space you need betweeb text and underline
          // ),
          // decoration: BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //   color: Color(0xff32AFC8),
          //   width: 2.0, // This would be the width of the underline
          // ))),
          child: Text(
            "TOP PICKS FOR YOU",
            style: ThemeApp()
                .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(20),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(7), 0, ScreenUtil().setWidth(7), 0),
          height: ScreenUtil().setWidth(303),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.productTrendingResponse!.data!.length,
              itemBuilder: (BuildContext context, index) {
                return Column(children: [
                  ProductCard(
                      value.productTrendingResponse!.data![index])
                ]);
              }),
        )
      ]);
    });
  }
}
