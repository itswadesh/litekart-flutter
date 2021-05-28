

import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:anne/model/user.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/utility/shared_preferences.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'api_endpoint.dart';
import 'graphQl.dart';

class ApiProvider{

  QueryMutation addMutation = QueryMutation();
  Dio dio = Dio();
  // Address Apis


  fetchAddressData() async {
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration.clientToQuery();
    try {
      var resultData = await _client1.mutate(
        MutationOptions(
          document: gql(addMutation.myAddresses()),
        ),
      );
      if (resultData.hasException) {
        print(resultData.exception);
        responseData ={
          "status":"error"
        };
      } else {
        if (resultData.data["myAddresses"] == null ||
            resultData.data["myAddresses"]["data"].length == 0) {
          responseData ={
            "status":"empty"
          };
        } else {
          responseData ={
            "status":"completed",
            "value":resultData.data["myAddresses"]
          };
        }
      }
    } catch (e) {
      print(e);
      responseData ={
        "status":"error"
      };
    }
    return responseData;
  }

  saveAddress(id, email, firstName, lastName, address, town, city, country,
      state, pin, phone) async {
    bool statusResponse;
    try {
      GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.mutate(
        MutationOptions(document: gql(addMutation.saveAddress()), variables: {
          'id': id,
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'address': address,
          'town': town,
          'city': city,
          'country': country,
          'state': state,
          'zip': int.parse(pin),
          'phone': phone,
        }),
      );
      if (result.hasException) {
        print(result.exception.graphqlErrors);
          statusResponse=false;
      } else {
        statusResponse=true;
      }
    } catch (e) {
      statusResponse=false;
    }
    return statusResponse;
  }

  deleteAddress(id) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    await _client.mutate(
      MutationOptions(
          document: gql(addMutation.deleteAddress()), variables: {'id': id}),
    );
  }

  fetchDataFromZip(zip) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.getLocationFromZip()),
          variables: {'zip': int.parse(zip)}),
    );

    if (result.hasException) {
      print(result.exception.toString());
      return null;
    } else {
      print(result.data.toString());
      return {
        "state": result.data["getLocationFromZip"]["state"],
        "country": result.data["getLocationFromZip"]["country"],
        "city": result.data["getLocationFromZip"]["city"],
      };
    }
  }


  // Auth Apis

  Future<User> getProfile() async {
    User _user;
    GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
    QueryResult resultData = await _client1.mutate(
      MutationOptions(
        document: gql(addMutation.me()),
      ),
    );
    if (resultData.hasException) {
      await deleteCookieFromSF();
    } else {
      _user = User.fromJson(resultData.data["me"]);
    }
    return _user;
  }

  editProfile(phone, firstName, lastName, email, gender) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(addMutation.updateProfile()), variables: {
          'phone': phone,
          'firstName': firstName,
          'email': email,
          'lastName': lastName,
          'gender': gender,
        }));
  }

  removeProfile() async{
    GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration1.clientToQuery();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(addMutation.signOut())));
    token = "";
    tempToken = "";
    deleteCookieFromSF();
  }


  // Banner Apis

   fetchBannerData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.banners()),
            variables: {"type": "banner"}),
      );
      if (resultData.hasException) {
        responseData = {
          "status" : "error"
        };
      } else {
        if (resultData.data["banners"] == null) {
          responseData = {
            "status" : "empty"
          };
        } else {
          responseData = {
            "status" : "completed",
            "value":resultData.data["banners"]
          };
        }
      }
    } catch (e) {
      responseData = {
        "status" : "error"
      };
      print(e);
    }
    return responseData;
  }

   fetchSliderData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.banners()),
            variables: {"type": "slider"}),
      );
      if (resultData.hasException) {
        responseData = {
          "status" : "error"
        };
      } else {
        if (resultData.data["banners"] == null) {
          responseData = {
            "status" : "empty"
          };
        } else {
          responseData = {
            "status" : "completed",
            "value":resultData.data["banners"]
          };
        }
      }
    } catch (e) {
      responseData = {
        "status" : "error"
      };
      print(e);
    }
    return responseData;
  }

  // brand Apis

   fetchBrandData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.brands()),
            variables: {"featured": true, "limit": 5, "page": 0},
            fetchPolicy: FetchPolicy.noCache),
      );
      if (resultData.hasException) {
        responseData = {
          "status" : "error"
        };
      } else {
        if (resultData.data["brands"] == null ||
            resultData.data["brands"]["data"].length == 0) {
          responseData = {
            "status" : "empty"
          };
        } else {
          responseData = {
            "status" : "completed",
            "value":resultData.data["brands"]
          };
        }
      }
    } catch (e) {
      responseData = {
        "status" : "error"
      };
    }
    return responseData;
  }


  // Cart Apis


  fetchCartData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
          document: gql(addMutation.cart()),
        ),
      );
      if (resultData.hasException) {
        print(resultData.exception.toString());
        responseData = {
          "status" : "error"
        };
      } else {
        if (resultData.data["cart"] == null ) {
          responseData = {
            "status" : "empty"
          };
        }
        else if(
        resultData.data["cart"]["items"].length == 0){
          responseData = {
            "status" : "empty"
          };
        }
        else {
          responseData = {
            "status" : "completed",
            "value":resultData.data["cart"]
          };
        }
      }
    } catch (e) {
      print(e);
      responseData = {
    "status" : "error"
    };
    }
    return responseData;
  }

  cartAddItem(pid, vid, qty, replace) async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(document: gql(addMutation.addToCart()), variables: {
          "pid": pid,
          "vid": vid,
          "qty": qty,
          "replace": replace,
          "options": "[]"
        }),
      );
      if (resultData.hasException) {
        print(resultData.exception.toString());
        responseData = {
          "status" : "error"
        };
      } else {
          token = tempToken;
          await addCookieToSF(token);

        if (resultData.data["addToCart"] == null ||
            resultData.data["addToCart"]["items"].length == 0) {
          responseData = {
            "status" : "empty"
          };
        } else {
          responseData = {
            "status" : "completed",
            "value":resultData.data["addToCart"]
          };
        }
      }
    } catch (e) {
      print(e.toString());
      responseData = {
        "status" : "error"
      };
    }
    return responseData;
  }

  applyCoupon(promocode) async {
    Map responseData ;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.applyCoupon()),
            variables: {"code": promocode}),
      );
      if (resultData.hasException) {

        responseData= {"status":false};
      } else {
        if (resultData.data["applyCoupon"] == null ||
            resultData.data["applyCoupon"]["items"].length == 0) {
          responseData= {"status":false};
        } else {
          responseData= {"status":true,"promocodeStatus":true};
        }
      }
    } catch (e) {
      print(e);
      responseData= {"status":false};
    }
    return responseData;
  }

  listCoupons() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
          document: gql(addMutation.coupons()),
        ),
      );
      if (resultData.hasException) {
        print(resultData.exception.toString());
        responseData = {
          "status":"error"
        };

      } else {
        if (resultData.data["coupons"] == null ||
            resultData.data["coupons"]["data"].length == 0) {
          responseData = {
            "status":"empty"
          };
        } else {
          responseData = {
            "status":"completed",
            "value":resultData.data["coupons"]
          };
        }
      }
    } catch (e) {
      responseData = {
        "status":"error"
      };
      print(e);
    }
    return responseData;
  }


  // category api

   fetchCategoryData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.categories()),
            variables: {"shopbycategory": true, "limit": 6, "page": 0}),
      );
      if (resultData.hasException) {
        print(resultData.exception);
        responseData = {
          "status":"error"
        };

      } else {
        if (resultData.data["categories"] == null ||
            resultData.data["categories"]["data"].length == 0) {
          responseData = {
            "status":"empty"
          };

        } else {
          responseData = {
            "status":"completed",
            "value":resultData.data["categories"]
          };
        }
      }
    } catch (e) {
      responseData = {
        "status":"error"
      };
      print(e);
    }
    return responseData;
  }

  // List Deals Api

  Future<void> fetchDealsData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
          document: gql(addMutation.listDeals()),
        ),
      );
      if (resultData.hasException) {
        responseData = {
          "status":"error"
        };
      } else {
        if (resultData.data == null ||
            resultData.data["listDeals"] == null ||
            resultData.data["listDeals"]["data"].length == 0 ||
            int.parse(resultData.data["listDeals"]["data"][0]["endTimeISO"]) <
                DateTime.now().millisecondsSinceEpoch) {
          responseData = {
            "status":"empty"
          };
        } else {
          responseData = {
            "status":"error",
            "value":resultData.data["listDeals"]
          };
        }
      }

      // _apiResponse = ApiResponse.completed(_categoriesResponse);
    } catch (e) {
      responseData = {
        "status":"error"
      };
      // _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    return responseData;
  }

  // product apis

  Future<void> fetchHotData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.products()), variables: {"hot": true}),
      );
      if (resultData.hasException) {
        responseData = {
          "status":"error"
        };
      } else {
        if (resultData.data["products"] == null ||
            resultData.data["products"]["data"].length == 0) {
          responseData = {
            "status":"empty"
          };
        } else {
          responseData = {
            "status":"completed",
            "value":resultData.data["products"]
          };
        }
      }
    } catch (e) {
      responseData = {
        "status":"error"
      };
      print(e);
    }
  return responseData;
  }
  Future<void> fetchYouMayLikeData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.products()), variables: {"sale": true}),
      );
      if (resultData.hasException) {
        responseData = {
          "status":"error"
        };
      } else {
        if (resultData.data["products"] == null ||
            resultData.data["products"]["data"].length == 0) {
          responseData = {
            "status":"empty"
          };
        } else {
          responseData = {
            "status":"completed",
            "value":resultData.data["products"]
          };
        }
      }
    } catch (e) {
      responseData = {
        "status":"error"
      };
      print(e);
    }
    return responseData;
  }
  Future<void> fetchSuggestedData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.products()), variables: {"new": true}),
      );
      if (resultData.hasException) {
        responseData = {
          "status":"error"
        };
      } else {
        if (resultData.data["products"] == null ||
            resultData.data["products"]["data"].length == 0) {
          responseData = {
            "status":"empty"
          };
        } else {
          responseData = {
            "status":"completed",
            "value":resultData.data["products"]
          };
        }
      }
    } catch (e) {
      responseData = {
        "status":"error"
      };
      print(e);
    }
    return responseData;
  }

  // wishlist api

  Future<void> fetchWishListData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(MutationOptions(
        document: gql(addMutation.myWishlist()),
      ));
      if (resultData.hasException) {
        responseData = {
          "status":"error"
        };
      } else {
        if (resultData.data["myWishlist"] == null ||
            resultData.data["myWishlist"]["data"].length == 0) {
          responseData = {
            "status":"empty"
          };
        } else {
          responseData = {
            "status":"completed",
            "value":resultData.data["myWishlist"]
          };
        }
      }
    } catch (e) {
      responseData = {
        "status":"error"
      };
      print(e);
    }
    return responseData;
  }

  toggleWishList(id) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    try {
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      await _client.mutate(
        MutationOptions(
            document: gql(addMutation.toggleWishList()),
            variables: {"product": id, "variant": id}),
      );
    } catch (e) {
      print(e);
    }
  }

  // Product List Api

  fetchProductList(categoryName,searchText,brand,color,size,page)async{
    print(categoryName);
   var response = await dio.get((ApiEndpoint()).productList, queryParameters: {
      "categories": categoryName,
      "q": searchText,
      "brands": brand,
      "colors": color,
      "sizes": size,
      "page": page
    });
   return response;
  }

  // checkout api

  checkout(addressId,paymentMode) async{
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.checkOut()),
          variables: {'address': addressId, 'paymentMethod': paymentMode}),
    );
    return result;
  }

  // cashfree api

  cashFreePayNow(selectedAddressId) async{
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult resultCashFree = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.cashfreePayNow()),
          variables: {
            'address': selectedAddressId,
          }),
    );
    return resultCashFree;
  }


  // fcm token

  saveFcmToken(id, token, platform, device_id,active) async{
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.saveFcmToken()),
          variables: {
            "id": id,
            "token": token,
            "platform": platform,
            "device_id": device_id,
            "active": active
          }),
    );
    return result;
  }

  myToken(page, search, limit, sort)async{
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.myTokens()),
        ),
    );
    if(result.hasException || result.data["count"]==0){
      return false;
    }
    return true;
  }
}