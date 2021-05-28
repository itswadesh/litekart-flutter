import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:anne/utility/query_mutation.dart';

import '../utility/graphQl.dart';
import '../utility/theme.dart';
import 'cart_logo.dart';

class ReturnPage extends StatefulWidget {
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
              padding: EdgeInsets.only(right: 10.0),
              // width: MediaQuery.of(context).size.width * 0.35,
              child: CartLogo())
        ],
      ),
      body: GraphQLProvider(
          client: graphQLConfiguration.initailizeClient(),
          child: CacheProvider(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Color(0xfff3f3f3),
                  child: getData()
                  // Query(
                  //     options: QueryOptions(
                  //         documentNode: gql(addMutation.cart()),
                  //         variables: {
                  //           //"category":widget.categoryId
                  //           "category":"5feb62db4f99304d1fc5386c"
                  //         }
                  //     ),
                  //     builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
                  //       if (result.hasException) {
                  //         print(result.exception.toString());
                  //         return errorMessage();
                  //       }
                  //       if (result.loading) {
                  //         return Loading();
                  //       }
                  //       print(jsonEncode(result.data));
                  //
                  //       if(result.data["cart"]==null){
                  //         return cartEmptyMessage();
                  //       }
                  //       else {
                  //         total = result.data["cart"]["subtotal"]-result.data["cart"]["discount"]["amount"]+result.data["cart"]["tax"]["cgst"]+result.data["cart"]["tax"]["sgst"]+result.data["cart"]["tax"]["igst"];
                  //
                  //         return getCartList(result.data["cart"]);
                  //       }
                  //     }
                  // ),
                  ))),
    );
  }

  getData() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
                child: Text(
              "ITEM FOR RETURN",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )),
            SizedBox(
              height: 20,
            ),
            progressCard(),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "Select Item for return",
                      style: ThemeApp().textThemeGrey(),
                    ),
                  ),
                  Container(
                    child: Text("Returning item (1)",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  )
                ],
              ),
            ),
            getProductList()
          ],
        ),
      ),
    );
  }

  progressCard() {
    return Container(
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            children: [
              stepIndicator(),
              SizedBox(
                height: 25,
              ),
              Container(
                  child: Text(
                "Return you product within 15 days after purchasing",
                style: ThemeApp().textThemeGrey(),
              )),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Text(
                      "Print return Invoice",
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                  ),
                  Icon(
                    Icons.print,
                    color: Colors.blue,
                    size: 18,
                  ),
                ],
              ),
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
            padding: EdgeInsets.fromLTRB(9.5, 5, 9.5, 5),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.pink, width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              "1",
              style: TextStyle(color: Colors.pink),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              color: currentStep > 1 ? Colors.pinkAccent : Color(0xfff3f3f3),
            ),
            height: 10,
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8.5, 5, 8.5, 5),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.pink, width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              "2",
              style: TextStyle(color: Colors.pink),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              color: currentStep > 2 ? Colors.pinkAccent : Color(0xfff3f3f3),
            ),
            height: 10,
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8.2, 5, 8.2, 5),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.pink, width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              "3",
              style: TextStyle(color: Colors.pink),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              color: currentStep > 3 ? Colors.pinkAccent : Color(0xfff3f3f3),
            ),
            height: 10,
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(7.9, 5, 7.9, 5),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.pink, width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              "4",
              style: TextStyle(color: Colors.pink),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
                color: currentStep > 4 ? Colors.pinkAccent : Color(0xfff3f3f3),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            height: 10,
          )
        ],
      ),
    );
  }

  getProductList() {
    return Container();
  }
}
