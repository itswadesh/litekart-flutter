import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:anne/repository/products_repository.dart';
import 'package:anne/response_handler/productListApiReponse.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/view/product_filter_drawer.dart';
import 'package:anne/components/widgets/cartEmptyMessage.dart';
import 'package:anne/components/widgets/loading.dart';
import 'package:anne/components/widgets/productViewCard.dart';

import 'package:anne/view/cart_logo.dart';

class ProductList extends StatefulWidget {
  final search;
  final category;
  final brandName;

  ProductList(this.search, this.category, this.brandName);

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
  String categoryName;
  final PagingController _pagingController = PagingController(firstPageKey: 0);
  List brandArr = [];
  List colorArr = [];
  List sizeArr = [];
  var brand = "";
  var color = "";
  var size = "";
  int page = 0;
  var count = 0;
  var facet;
  TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    categoryName = widget.category;
    searchText.text = widget.search;
    brand = widget.brandName;
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
              color: Colors.black54,
            ),
          ),
          title: Center(
              // width: MediaQuery.of(context).size.width * 0.39,
              child: Text(
            "Product List",
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
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Container(
                  color: Color(0xfff3f3f3),
                  child: Container(child: getProductList()))),
        ));
  }

  Widget getProductList() {
    return Column(children: [
      Container(
        height: ScreenUtil().setWidth(43),
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(27),
            ScreenUtil().setWidth(15),
            ScreenUtil().setWidth(16),
            ScreenUtil().setWidth(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$count Products Found",
              style: TextStyle(
                  color: Color(0xff616161),
                  fontSize: ScreenUtil().setWidth(16)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                count > 0
                    ? InkWell(
                        onTap: () {
                          // key.currentState.openEndDrawer();

                          showMaterialModalBottomSheet(
                            context: context,
                            builder: (context) => ProductFilterDrawer(
                                facet, brandArr, colorArr, sizeArr,
                                (bn, cl, sz) {
                              brand = "";
                              color = "";
                              size = "";
                              bn.forEach((element) {
                                brand = brand + element + ",";
                              });
                              cl.forEach((element) {
                                color = color + element + ",";
                              });
                              sz.forEach((element) {
                                size = size + element + ",";
                              });
                              print(brand);
                              brandArr = bn;
                              colorArr = cl;
                              sizeArr = sz;
                              page = 0;
                              print(brand);
                              _pagingController.refresh();
                            }),
                          );
                        },
                        child: Icon(
                          Icons.sort,
                          size: ScreenUtil().setWidth(22),
                          color: Color(0xffee7625),
                        ))
                    : Container()
              ],
            )
          ],
        ),
      ),
      Container(
        color: Colors.grey.shade300,
        height: MediaQuery.of(context).size.height * 0.89,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: RefreshIndicator(
          onRefresh: () => Future.sync(
            () {
              page = 0;
              _pagingController.refresh();
            },
          ),
          child: PagedGridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio:
                    ScreenUtil().setWidth(183) / ScreenUtil().setWidth(228),
                crossAxisCount: 2),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) =>
                    ProductViewCard(item ?? ProductListData()),
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
        categoryName, searchText.text, brand, color, size, page);
    if (response.statusCode == 200) {
      try {
        print(response.data.toString());
        count = response.data["count"];
        facet = response.data["facets"];

        final isLastPage = response.data["data"].length < 40;
        if (isLastPage) {
          _pagingController.appendLastPage(response.data["data"]);
        } else {
          final nextPageKey = pageKey + response.data["data"].length;
          _pagingController.appendPage(response.data["data"], nextPageKey);
        }
      } catch (error) {
        print(error.toString());
        _pagingController.error = error;
      }
      setState(() {
        page = page + 1;
      });
    }
  }
}
