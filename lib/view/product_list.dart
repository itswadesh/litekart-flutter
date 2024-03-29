import 'dart:developer';

import 'package:anne/components/widgets/productListCard.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/view/product_sort_drawer.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../repository/products_repository.dart';
import '../../response_handler/productListApiReponse.dart';
import '../../utility/query_mutation.dart';
import '../../view/product_filter_drawer.dart';
import '../../components/widgets/cartEmptyMessage.dart';
import '../../components/widgets/loading.dart';
import '../../values/route_path.dart' as routes;
import '../../view/cart_logo.dart';

class ProductList extends StatefulWidget {
  final search;
  final category;
  final brandName;
  final parentBrand;
  final brandId;
  final urlLink;
  ProductList(this.search, this.category, this.brandName,this.parentBrand,this.brandId,this.urlLink);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductList();
  }
}

class _ProductList extends State<ProductList> {
  Dio dio = new Dio();
  QueryMutation addMutation = QueryMutation();
  var searchVisible = false;
  ProductsRepository productsRepository = ProductsRepository();
  // ProductResponse productResponse;
  String? categoryName;
  final PagingController _pagingController = PagingController(firstPageKey: 0);
  List brandArr = [];
  List colorArr = [];
  List sizeArr = [];
  List genderArr = [];
  // List priceRangeArr = [];
  // List ageGroupArr = [];
  // List discountArr = [];
  String? urlLink = "";
  String? brandId = "";
  String? brand = "";
  var color = "";
  String? parentBrand = "";
  var size = "";
  var gender = "";
  var priceRange = "";
  var ageGroup = "";
  var discount = "";
  int page = 0;
  var count = 0;
  String? sort = "";
  var facet;
  TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    categoryName = widget.category;
    searchText.text = widget.search;
    brand = widget.brandName;
    parentBrand = widget.parentBrand;
    brandId = widget.brandId;
    urlLink = widget.urlLink;
    _pagingController.addPageRequestListener((pageKey) {
      fetchProduct(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    //  _scrollController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

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
              color: Color(0xff6161616),
              size: ScreenUtil().setWidth(28)
            ),
          ),
          title: Column(
            children: [
              Text(
                "$count products",
                style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: ScreenUtil().setSp(
                      16,
                    )),
              )
            ],
          ) ,
          actions: [
        Container(
        padding: EdgeInsets.only(top: ScreenUtil().setWidth(2)),
      child:
            InkWell(
                onTap: () {
                  locator<NavigationService>().pushNamed(routes.SearchPage);
                },
                child: Icon(
                  Icons.search,
                  size: ScreenUtil().setWidth(28),
                  color: Color(0xff616161),
                ))),
            SizedBox(
              width: ScreenUtil().setWidth(24),
            ),
            // InkWell(
            //     onTap: () {
            //       if (Provider.of<ProfileModel>(context, listen: false).user == null)
            //       {
            //         locator<NavigationService>().pushNamed(routes.LoginRoute);
            //       }
            //       else {
            //         locator<NavigationService>().pushNamed(
            //             routes.ManageOrder);
            //       }
            //     },
            //     child: Icon(
            //         Icons.shopping_bag_outlined,
            //       size: 25,
            //       color: Color(0xff616161),
            //     )),
            // SizedBox(
            //   width: ScreenUtil().setWidth(24),
            // ),
            InkWell(
                onTap: () {
                  if (Provider.of<ProfileModel>(context, listen: false).user == null)
                  {
                    locator<NavigationService>().pushNamed(routes.LoginRoute);
                  }
                  else {
                    locator<NavigationService>().pushNamed(
                        routes.Wishlist);
                  }
                },
                child: Icon(
                  Icons.favorite_border_outlined,
                  size: ScreenUtil().setWidth(28),
                  color: Color(0xff616161),
                )),
            SizedBox(width: ScreenUtil().setWidth(24),),
            CartLogo(25),
            SizedBox(width: ScreenUtil().setWidth(12),),
          ],
        ),
        body: Stack(children:[Container(
          color: Color(0xfff3f3f3),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Container(
                
                  color: Color(0xfff3f3f3),
                  child: Container(child: getProductList()))),
        ),
          count > 0 ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setWidth(50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Color(0xfff3f3f3)))
                    //borderRadius:BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       InkWell(
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(color: Color(0xffd3d3d3))
                                    )
                                ),
                                height: ScreenUtil().setWidth(50),
                                width: ScreenUtil().setWidth(207),
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Icon(
                                    FontAwesomeIcons.sort,
                                    size: ScreenUtil().setWidth(19),
                                    color: AppColors.primaryElement,
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10),),
                                  Text("Sort By",style: TextStyle(color: AppColors.primaryElement,fontFamily: 'Inter'),)
                                ],))),
                            onTap: () {
                              showMaterialModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(ScreenUtil().setWidth(25)),
                                        topRight: Radius.circular(ScreenUtil().setWidth(25)),
                                      )
                                  ),
                                  context: context,
                                  builder: (context) => Container(
                                    decoration: BoxDecoration(

                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(ScreenUtil().setWidth(25)),
                                          topRight: Radius.circular(ScreenUtil().setWidth(25)),
                                        )
                                    ),
                                    child: ProductSortDrawer(
                                        sort,
                                            (st) {
                                          sort = st;
                                          page = 0;
                                          _pagingController.refresh();
                                        }),
                                  ));
                             // showSortPopup();
                            },
                          ),
                      InkWell(
                        child: Container(
                            height: ScreenUtil().setWidth(50),
                            width: ScreenUtil().setWidth(207),
                            child: Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [  Icon(
                              FontAwesomeIcons.filter,
                              size: ScreenUtil().setWidth(16),
                              color: AppColors.primaryElement,
                            ),
                              SizedBox(width: ScreenUtil().setWidth(10),),
                              Text("Filter",style: TextStyle(color: AppColors.primaryElement,fontFamily: 'Inter'),)
                            ]))),
                        onTap: () {
                          showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(ScreenUtil().setWidth(25)),
                                    topRight: Radius.circular(ScreenUtil().setWidth(25)),
                                  )
                              ),
                              context: context,
                              builder: (context) => Container(
                                decoration: BoxDecoration(

                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(ScreenUtil().setWidth(25)),
                                      topRight: Radius.circular(ScreenUtil().setWidth(25)),
                                    )
                                ),
                                child: ProductFilterDrawer(
                                    facet, brandArr, colorArr, sizeArr,genderArr,priceRange,ageGroup,discount,
                                        (bn, cl, sz,gd,pr,ag,dc) {
                                      brand = "";
                                      color = "";
                                      size = "";
                                      gender = "";
                                      priceRange = "";
                                      ageGroup = "";
                                      discount = "";
                                      bn.forEach((element) {
                                        brand = brand! + element + ",";
                                      });
                                      cl.forEach((element) {
                                        color = color + element + ",";
                                      });
                                      sz.forEach((element) {
                                        size = size + element + ",";
                                      });
                                      gd.forEach((element) {
                                        gender = gender + element + ",";
                                      });
                                      // pr.forEach((element) {
                                      //   priceRange = priceRange + element + ",";
                                      // });
                                      // ag.forEach((element) {
                                      //   ageGroup = ageGroup + element + ",";
                                      // });
                                      // dc.forEach((element) {
                                      //   discount = discount + element + ",";
                                      // });

                                      brandArr = bn;
                                      colorArr = cl;
                                      sizeArr = sz;
                                      genderArr = gd;
                                      priceRange = pr;
                                      ageGroup = ag;
                                      discount = dc;
                                      page = 0;

                                      _pagingController.refresh();
                                    }),
                              ));
                        },
                      ),
                    ],))):SizedBox.shrink(),
        ]));
  }

  Widget getProductList() {
    return Column(children: [
      Container(
        color: Color(0xfff3f3f3),
        height: MediaQuery.of(context).size.height-ScreenUtil().setWidth(140),
        //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: RefreshIndicator(
          onRefresh: () => Future.sync(
            () {
              page = 0;
              _pagingController.refresh();
            },
          ),
          child: PagedGridView(
            padding: EdgeInsets.all(0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio:
                    ScreenUtil().setWidth(183) / ScreenUtil().setWidth(255),
                crossAxisCount: 2),
            pagingController: _pagingController,
            builderDelegate:  PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) =>
                    ProductListCard(item??ProductListData(images: [], imgCdn: "")),
                // firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
                //   error: _pagingController.error,
                //   onTryAgain: () => _pagingController.refresh(),
                // ),
                // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
                //   error: _pagingController.error,
                //   onTryAgain: () => _pagingController.retryLastFailedRequest(),
                // ),
                firstPageProgressIndicatorBuilder: (_) => Loading(),
                newPageProgressIndicatorBuilder: (_) => Loading(),
                noItemsFoundIndicatorBuilder: (_) =>
                    cartEmptyMessage("search", "No Product Found")),
            // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
          ),
        ),
      ),

    ]);
  }

  fetchProduct(pageKey) async {
    var response;
    response = await productsRepository.fetchProductList(
        categoryName, searchText.text, brand, color, size, gender,priceRange,ageGroup,discount,page, parentBrand,brandId,urlLink,sort);
    log(response.toString());
    if (response.statusCode == 200) {
      try {
          count = response.data["count"] ?? 0;
          facet = response.data["facets"];

          final isLastPage = response.data["data"].length < 24;
          if (isLastPage) {
            _pagingController.appendLastPage(response.data["data"]);
          } else {
            final nextPageKey = pageKey + response.data["data"].length;
            _pagingController.appendPage(response.data["data"], nextPageKey);
          }
      } catch (error) {

        _pagingController.error = error;
      }
      setState(() {
        page = page + 1;
      });
    }
  }

  void showSortPopup() {
   var sorts = [
      { "name": 'Relevance', "val": "" },
      { "name": 'Whats New', "val": '-createdAt' },
      { "name": 'Price low to high', "val": 'price' },
      { "name": 'Price high to low', "val": '-price' },
    ];
    showDialog(

        context: context,
        builder: (context) {
          return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sort Products",
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
              content:  Container(
                      height: ScreenUtil().setWidth(320),
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
                          Container(
                            height: ScreenUtil().setWidth(250),
                            child: ListView.builder(
                                itemCount: sorts.length,
                                itemBuilder: (BuildContext build, index) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                sort = sorts[index]["val"];
                                                page=0;
                                                _pagingController.refresh();
                                                Navigator.pop(context);
                                              },
                                              child: ((sorts[index]["val"] ==
                                                  sort))
                                                  ? Icon(
                                                Icons.check_box,
                                                color: AppColors.primaryElement,
                                                size:
                                                ScreenUtil().setWidth(18),
                                              )
                                                  : Icon(
                                                Icons.check_box_outline_blank,
                                                color: AppColors.primaryElement,
                                                size:
                                                ScreenUtil().setWidth(18),
                                              ),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(20),
                                            ),
                                            DottedBorder(
                                                color: AppColors.primaryElement,
                                                dashPattern: [
                                                  ScreenUtil().setWidth(4),
                                                  ScreenUtil().setWidth(2)
                                                ],
                                                child: Container(
                                                  height: ScreenUtil().setWidth(28),
                                                  width: ScreenUtil().setWidth(150),
                                                  child: Center(
                                                      child: Text(
                                                        sorts[index]["name"]!,
                                                        style: TextStyle(
                                                            color: AppColors.primaryElement,
                                                            fontSize:
                                                            ScreenUtil().setSp(
                                                              13,
                                                            )),
                                                      )),
                                                ))
                                          ],
                                        ),

                                        SizedBox(
                                          height: ScreenUtil().setWidth(38),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ));});
  }
}
