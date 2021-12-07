import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http_parser/http_parser.dart';
import '../../model/user.dart';
import '../../utility/query_mutation.dart';
import '../../utility/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'api_endpoint.dart';
import 'graphQl.dart';
import 'package:mime/mime.dart';
import "package:http/http.dart" as Multipartfile;
class ApiProvider {
  QueryMutation addMutation = QueryMutation();
  Dio dio = Dio();

  // Schedule Video
  saveScheduleDemos(id,pid,scheduleDateTime,title) async{

    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration.clientToQuery();
    try {
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.saveScheduleDemo()),
            variables: {
              "id":id,
              "product":pid,
              "scheduleDateTime":scheduleDateTime,
              "title":title,
            }
        ),
      );

      if (resultData.hasException) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
     return false;
    }
  }

  deleteScheduleDemo(id) async{

    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration.clientToQuery();
    try {
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.deleteScheduleDemo()),
            variables: {
              "id":id,
            }
        ),
      );

      if (resultData.hasException) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }


  fetchMyScheduleDemos() async{
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration.clientToQuery();
    try {
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.myScheduleDemos()),
            variables: {
        // "page": page,
        // "skip": skip,
        // "limit": limit,
        // "search": search,
        // "sort": sort,
        // "q": q
            }
        ),
      );

      if (resultData.hasException) {

        responseData = {"status": "error"};
      } else {
        if (resultData.data!["myScheduleDemos"] == null || resultData.data!["myScheduleDemos"]["data"].length==0) {
          responseData = {"status": "empty"};
        } else {

          responseData = {
            "status": "completed",
            "value": resultData.data!["myScheduleDemos"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
    }

    return responseData;
  }



  // Channels

  fetchChannelData(page, skip, limit, search, sort, user, q) async {
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration.clientToQuery();
    try {
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.channels()),
        variables: {
              "page":page,
          "skip":skip,
          "limit":limit,
          "search":search,
          "sort":sort,
          "user":user,
          "q":q,
          "upcoming":true
        }
        ),
      );

      if (resultData.hasException) {
        
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["channels"] == null || resultData.data!["channels"]["data"].length==0) {
          responseData = {"status": "empty"};
        } else {

          responseData = {
            "status": "completed",
            "value": resultData.data!["channels"]
          };
        }
      }
    } catch (e) {
 
      responseData = {"status": "error"};
    }
    return responseData;
  }

  neteaseToken(id) async{
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration.clientToQuery();
    try {
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.neteaseToken()),
            variables: {
              "channel":id
            }
        ),
      );

      if (resultData.hasException) {

        responseData = {"status": "error"};
      } else {
        if (resultData.data!["neteaseToken"] == null) {
          responseData = {"status": "empty"};
        } else {

          responseData = {
            "status": "completed",
            "value": resultData.data!["neteaseToken"]
          };
        }
      }
    } catch (e) {

      responseData = {"status": "error"};
    }
    return responseData;
  }



// Store

  storeOne() async {
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration.clientToQuery();
    try {
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.store()),
        variables: {"domain":ApiEndpoint().domainName}
        ),
      );

      if (resultData.hasException) {
        
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null || resultData.data!["storeOne"] == null) {
          responseData = {"status": "empty"};
        } else {
          
          responseData = {
            "status": "completed",
            "value": resultData.data!["storeOne"]
          };
        }
      }
    } catch (e) {
     
      responseData = {"status": "error"};
    }
    return responseData;
  }

  // settings

  settings() async {
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration.clientToQuery();
    try {
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.settings())),
      );
      if (resultData.hasException) {
       
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["settings"] == null) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["settings"]
          };
        }
      }
    } catch (e) {
     
      responseData = {"status": "error"};
    }
    return responseData;
  }

  // Product Detail api

  fetchProductDetailApi(productId) async {
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration.clientToQuery();
    try {
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.product()), variables: {"id": productId}),
      );
      if (resultData.hasException) {
       
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["product"] == null) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["product"]
          };
        }
      }
    } catch (e) {
      
      responseData = {"status": "error"};
    }
    return responseData;
  }

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
      
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["myAddresses"] == null ||
            resultData.data!["myAddresses"]["data"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["myAddresses"]
          };
        }
      }
    } catch (e) {
     
      responseData = {"status": "error"};
    }
    return responseData;
  }

  saveAddress(id, email, firstName, lastName, address, city, country,
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
         // 'town': town,
          'city': city,
          'country': country,
          'state': state,
          'zip': int.parse(pin),
          'phone': phone,
          'store':store!.id
        }),
      );
      print(result.toString());
      if (result.hasException) {
        
        statusResponse = false;
      } else {
        statusResponse = true;
      }
    } catch (e) {
      statusResponse = false;
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

  fetchLocation(lat,long) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.getLocation()),
          variables: {'lat': lat,'lng':long}),
    );
    if (result.hasException) {
      return null;
    } else {
      return {
        "state": result.data!["getLocation"]["state"],
        "country":"India",
       // "country": result.data!["getLocation"]["country"],
        "city": result.data!["getLocation"]["city"],
        "zip": result.data!["getLocation"]["zip"]
      };
    }
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
     
      return null;
    } else {
      
      return {
        "state": result.data!["getLocationFromZip"]["state"],
        "country": result.data!["getLocationFromZip"]["country"],
        "city": result.data!["getLocationFromZip"]["city"],

      };
    }
  }

  // Auth Apis

  Future<bool> facebookMobileLogin(accessToken) async {
    GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
    print(accessToken);
    QueryResult resultData = await _client1.mutate(
      MutationOptions(
          document: gql(addMutation.facebookMobileLogin()),
          variables: {
            "accessToken":accessToken
          }
      ),
    );
    if (resultData.hasException) {
      print(resultData.toString());
      return false;
    }
    return true;
  }

  Future<bool> signInWithApple(accessToken) async {
    GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();

    QueryResult resultData = await _client1.mutate(
      MutationOptions(
          document: gql(addMutation.signInWithApple()),
          variables: {
            "code":accessToken
          }
      ),
    );
    print(resultData.toString());
    if (resultData.hasException) {
      return false;
    }
    return true;
  }

  Future<bool> googleOneTap(accessToken) async {
    GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();

    QueryResult resultData = await _client1.mutate(
      MutationOptions(
          document: gql(addMutation.googleOneTap()),
          variables: {
            "credential":accessToken
          }
      ),
    );
    print(resultData.toString());
    if (resultData.hasException) {
      return false;
    }
    return true;
  }



  Future<User?> getProfile() async {
    User? _user;
    GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
    GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
    
    QueryResult resultData = await _client1.mutate(
      MutationOptions(
        document: gql(addMutation.me()),
        variables: {
          "store":store!.id
        }
      ),
    );
    if (resultData.hasException) {
    
      await deleteCookieFromSF();
    } else {
      _user = User.fromJson(resultData.data!["me"]);
    }
    return _user;
  }

  editProfile(phone, firstName, lastName, email, gender, image) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
     if(image==null){
       QueryResult result = await _client.mutate(
        MutationOptions(document: gql(addMutation.updateProfile()), variables: {
      'phone': phone,
      'firstName': firstName,
      'email': email,
      'lastName': lastName,
      'gender': gender,
          "store":store!.id
    }));
    if(!result.hasException){
      return true;
    }
  }
  else {
    // var byteData = image.readAsBytesSync();
    //   final mimeTypeData = lookupMimeType(image.path,
    //       headerBytes: [0xFF, 0xD8])!.split('/');
    //
    //   var file = Multipartfile.MultipartFile.fromString(
    //       "image",
    //       image.path,
    //       filename: image.path,
    //       contentType: MediaType(
    //           mimeTypeData[0], mimeTypeData[1])
    //   );
      QueryResult resultLink = await _client.mutate(
        MutationOptions(
            document: gql(
                addMutation.fileUpload()),
            variables: {
              'files': [image],
              'folder': 'user',
              'store': store!.id
            }),
      );
      print(resultLink.toString());
      if (!resultLink.hasException && resultLink.data!=null && resultLink.data!['fileUpload'] != null) {
        QueryResult result =   await _client.mutate(
            MutationOptions(
                document: gql(addMutation.updateProfile()), variables: {
                  'avatar': resultLink
                      .data!['fileUpload']
                  [0]['url'],
              'phone': phone,
              'firstName': firstName,
              'email': email,
              'lastName': lastName,
              'gender': gender,
              "store":store!.id
            }));
        if(!result.hasException){
          return true;
        }
        print(result.exception.toString());
      }

      return false;
    }
  }

  removeProfile() async {
    GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration1.clientToQuery();
    await _client
        .mutate(MutationOptions(document: gql(addMutation.signOut()),variables: {
          "store":store!.id
    }));
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
            document: gql(addMutation.groupByBanner()),
            variables: {"type": "hero","pageId":"home","store":store!.id
              }),
      );
      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["groupByBanner"] == null ||
            resultData.data!["groupByBanner"].length == null) {
          responseData = {"status": "empty"};
        } else {
          responseData = {"status": "completed", "value": resultData.data};
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
    }
    return responseData;
  }

  fetchPickedBannerData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.groupByBanner()),
            variables: {"type": "picked","pageId":"home","store":store!.id
            }),
      );
      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {

        if (resultData.data!["groupByBanner"] == null ||
            resultData.data!["groupByBanner"].length == null) {
          responseData = {"status": "empty"};
        } else {
          responseData = {"status": "completed", "value": resultData.data};
        }
      }
    } catch (e) {
      responseData = {"status": "error"};

    }
    return responseData;
  }

  fetchBanners(
      {String? pageId, required String type, String? sort, bool? active}) async {
    Map<String, dynamic> variables = {"type": type};
    if (pageId != null) variables['pageId'] = pageId;
    if (sort != null) variables['sort'] = sort;
    variables['isMobile'] = true;
    variables['store'] = store!.id;
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.banners()), variables: variables),
      );
      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {

        if (resultData.data!["banners"] == null) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["banners"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
  
    }
    return responseData;
  }

  fetchSubBrand({required String? pageId}) async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(document: gql(addMutation.subBrands()), variables: {
          "limit": 10,
          "page": 0,
          "sort": "sort",
          "parent": pageId,
          "featured": true
        }),
      );
      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["brands"] == null) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["brands"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
     
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
            variables: {"sort": "sort", "limit": 5, "page": 0,
              'store':store!.id},
            fetchPolicy: FetchPolicy.noCache),
      );
      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["brands"] == null ||
            resultData.data!["brands"]["data"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["brands"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
    }
    return responseData;
  }

  fetchParentBrandData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.parentBrands()),
            variables: {"featured": true},
            fetchPolicy: FetchPolicy.noCache),
      );
      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["parentBrands"] == null ||
            resultData.data!["parentBrands"]["data"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["parentBrands"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
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
          document: gql(addMutation.cart(),),
          variables: {
            'store':store!.id
          }
        ),
      );

      if (resultData.hasException) {
        
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["cart"] == null) {
          responseData = {"status": "empty"};
        } else if (resultData.data!["cart"]["items"] == null ||
            resultData.data!["cart"]["items"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["cart"]
          };
        }
      }
    } catch (e) {
      
      responseData = {"status": "error"};
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
        
        responseData = {"status": "error"};
      } else {
        token = tempToken!;
        await addCookieToSF(token);

        if (resultData.data!["addToCart"] == null ||
            resultData.data!["addToCart"]["items"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["addToCart"]
          };
        }
      }
    } catch (e) {
     
      responseData = {"status": "error"};
    }
    return responseData;
  }

  applyCoupon(promocode) async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.applyCoupon()),
            variables: {"code": promocode}),
      );
      if (resultData.hasException) {
        responseData = {"status": false};
      } else {
        if (resultData.data!["applyCoupon"] == null ||
            resultData.data!["applyCoupon"]["items"].length == 0) {
          responseData = {"status": false};
        } else {
          responseData = {"status": true, "promocodeStatus": true};
        }
      }
    } catch (e) {
      
      responseData = {"status": false};
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
        
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["coupons"] == null ||
            resultData.data!["coupons"]["data"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["coupons"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
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
            variables: {"shopbycategory": true,
              'store':store!.id,'img':true,'sort':"featuredSort"}),
      );
      if (resultData.hasException) {

        responseData = {"status": "error"};
      } else {
        if (resultData.data!["categories"] == null ||
            resultData.data!["categories"]["data"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          
          responseData = {
            "status": "completed",
            "value": resultData.data!["categories"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
    }
    return responseData;
  }

  // List Deals Api

   fetchDealsData() async {
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
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null ||
            resultData.data!["listDeals"] == null ||
            resultData.data!["listDeals"]["data"].length == 0 ||
            int.parse(resultData.data!["listDeals"]["data"][0]["endTimeISO"]) <
                DateTime.now().millisecondsSinceEpoch) {
          responseData = {"status": "empty"};
        } else {

          responseData = {
            "status": "error",
            "value": resultData.data!["listDeals"]
          };
        }
      }

      // _apiResponse = ApiResponse.completed(_categoriesResponse);
    } catch (e) {
      responseData = {"status": "error"};
      // _apiResponse = ApiResponse.error(e.toString());
      
    }
    return responseData;
  }

  // product apis
	
	fetchRecommendedProducts() async{
	 Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      log("store id is as "+store!.id!);
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.products()), variables: {'new':true , 'store':store!.id}),
      );
      log(resultData.toString());
      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null || resultData.data!["products"] ==null || 
            resultData.data!["products"]["data"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {"status": "completed", "value": resultData.data!["products"]["data"]};
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
    }
    return responseData;	
	}

  fetchHotData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.trending()), variables: {"type": "hot"}),
      );

      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null ||
            resultData.data!["trending"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {"status": "completed", "value": resultData.data};
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
    }
    return responseData;
  }
	
	

   fetchYouMayLikeData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.trending()), variables: {"type": "sale"}),
      );

      if (resultData.hasException) {
       
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null ||
            resultData.data!["trending"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          
          responseData = {"status": "completed", "value": resultData.data};
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
    }
    return responseData;
  }

   fetchSuggestedData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
        MutationOptions(
            document: gql(addMutation.trending()), variables: {"type": "new"}),
      );

      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null ||
            resultData.data!["trending"].length == 0) {
          responseData = {"status": "empty"};
        } else {

          responseData = {"status": "completed", "value": resultData.data};
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
    }
    return responseData;
  }

  // wishlist api

   fetchWishListData() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(MutationOptions(
        document: gql(addMutation.myWishlist()),
        variables: {
          "store":store!.id
        }
      ));

   

      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data!["myWishlist"] == null ||
            resultData.data!["myWishlist"]["data"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["myWishlist"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
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
      
    }
  }

  // Product List Api
  fetchProductList(
      categoryName,
      searchText,
      brand,
      color,
      size,
      gender,
      priceRange,
      ageGroup,
      discount,
      page,
      parentBrand,
      brandId,
      urlLink,
      sort) async {
    String? cn = "";
    String? st = "";
    String? br = "";
    String? cl = "";
    String? sz = "";
    String? gd = "";
    String? pr = "";
    String? ag = "";
    String? dc = "";
    String? pb = "";
   
    if (urlLink != "" && urlLink != null) {
      if (urlLink.contains(apiEndpoint.externalLink)) {
        if (await canLaunch(urlLink)) {
          await launch(urlLink);
        } else
          // can't launch url, there is some error
          throw "Could not launch $urlLink";
      } else if (urlLink.contains(apiEndpoint.categoryLink) ||
          urlLink.contains(apiEndpoint.searchLink) ||
          urlLink.contains("/search?")) {
        cn = urlLink.contains(ApiEndpoint().categoryLink)
            ? (urlLink.split(ApiEndpoint().categoryLink)[1]).split(
                "${urlLink.split(ApiEndpoint().categoryLink)[1].contains("?") ? "?" : "\n"}")[0]
            : "";
        st = urlLink.contains(ApiEndpoint().searchLink)
            ? (urlLink.split(ApiEndpoint().searchLink)[1]).split(
                "${urlLink.split(ApiEndpoint().searchLink)[1].contains("?") ? "?" : "\n"}")[0]
            : "";
        br = urlLink.contains("brands=")
            ? (urlLink.split("brands=")[1]).split(
                "${urlLink.split("brands=")[1].contains("&") ? "&" : "\n"}")[0]
            : "";
        cl = urlLink.contains("colors=")
            ? (urlLink.split("colors=")[1]).split(
                "${urlLink.split("colors=")[1].contains("&") ? "&" : "\n"}")[0]
            : "";
        sz = urlLink.contains("sizes=")
            ? (urlLink.split("sizes=")[1]).split(
                "${urlLink.split("sizes=")[1].contains("&") ? "&" : "\n"}")[0]
            : "";
        gd = urlLink.contains("genders=")
            ? (urlLink.split("genders=")[1]).split(
                "${urlLink.split("genders=")[1].contains("&") ? "&" : "\n"}")[0]
            : "";
        pr = urlLink.contains("price=")
            ? (urlLink.split("price=")[1]).split(
                "${urlLink.split("price=")[1].contains("&") ? "&" : "\n"}")[0]
            : "";
        ag = urlLink.contains("age=")
            ? (urlLink.split("age=")[1]).split(
                "${urlLink.split("age=")[1].contains("&") ? "&" : "\n"}")[0]
            : "";
        dc = urlLink.contains("discount=")
            ? (urlLink.split("discount=")[1]).split(
                "${urlLink.split("discount=")[1].contains("&") ? "&" : "\n"}")[0]
            : "";
        pb = urlLink.contains("parentBrands=")
            ? (urlLink.split("parentBrands=")[1]).split(
                "${urlLink.split("parentBrands=")[1].contains("&") ? "&" : "\n"}")[0]
            : "";
        // bi = urlLink.contains("brand=") ? (urlLink.split("brand=")[1]).split(
        //     "${urlLink.split("brand=")[1].contains("&") ? "&" : "\n"}")[0] : "";
      }
    }
    print((ApiEndpoint()).productList);
    print(categoryName + cn);


   
    var response = await dio.get((ApiEndpoint()).productList!, queryParameters: {
      "categories": categoryName + cn,
      "q": searchText + st,
      "brands": brand + br,
      "colors": color + cl,
      "sizes": size + sz,
      "genders": gender + gd,
      "price": priceRange + pr,
      "age": ageGroup + ag,
      "discount": discount + dc,
      "sort": sort,
      "page": page,
      "parentBrands": parentBrand + pb,
      "store": store!.id,
      // "brand": bi
    });

    return response;
  }

  // checkout api

  checkout(addressId, paymentMode) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.checkOut()),
          variables: {'address': addressId, 'paymentMethod': paymentMode}),
    );
    return result;
  }

  order(id) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.order()), variables: {'id': id}),
    );
    return result;
  }

  paySuccessPageHit(orderId,paymentReferenceId) async {
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    try{
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.paySuccessPageHit()),
          variables: {'orderId': orderId,'paymentReferenceId':paymentReferenceId}),
    );

    if (result.hasException) {

      responseData = {"status": "error"};
    } else {
      if (result.data==null||result.data!["paySuccessPageHit"] == null) {
        responseData = {"status": "empty"};
      } else {
        responseData = {
          "status": "completed",
          "value": result.data!["paySuccessPageHit"]
        };
      }
    }
  } catch (e) {

  responseData = {"status": "error"};

  }
    return responseData;
  }


  // Stripe APi

  brainTreeToken(id) async{
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    try{
    var result = await _client.mutate(
      MutationOptions(document: gql(addMutation.brainTreeToken()),
      variables: {
        "address":id
      }
      ),
    );
    if (result.hasException) {
      responseData = {"status": "error"};
    } else {
      if (result.data==null||result.data!["braintreeToken"] == null) {

        responseData = {"status": "empty"};
      } else {
        responseData = {
          "status": "completed",
          "value": result.data!["braintreeToken"]
        };
      }
    }
  } catch (e) {
  responseData = {"status": "error"};

  }
  return responseData;
  }

  brainTreeMakePayment(nonce,tokenID) async{
    Map responseData;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    try{
    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(addMutation.brainTreeMakePayment()),
          variables: {
            "nonce":nonce,
            "token":tokenID
          }
      ),
    );


    if (result.hasException) {
      responseData = {"status": "error"};
    } else {
      if (result.data==null || result.data!["braintreeMakePayment"] == null) {
        responseData = {"status": "empty"};
      } else {
        responseData = {
          "status": "completed",
          "value": result.data!["braintreeMakePayment"]
        };
      }
    }
  } catch (e) {
  responseData = {"status": "error"};

  }
  return responseData;
  }

  //


  stripeMobile(addressId) async{
    Map resultData ;
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult resultStripe = await _client.mutate(
      MutationOptions(document: gql(addMutation.stripeMobile()), variables: {
        'address': addressId
      }),
    );
   
    if(resultStripe.hasException){
      resultData = {
        "status":"error",
        "error": resultStripe.exception.toString()
      };
    }
    else{
      if(resultStripe.exception!=null){
        resultData = {
          "status":"error",
          "error": resultStripe.exception.toString()
        };
      }
      else {
        resultData = {
          "status": "completed",
          "value": resultStripe.data!["stripeMobile"]
        };
      }
    }
    return resultData;
  }

// paymentMethod

  paymentMethods() async{
    Map responseData;

    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
          MutationOptions(document: gql(addMutation.paymentMethods()), variables: {
            "store":store!.id
          }));

      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null ||
            resultData.data!["paymentMethods"] == null) {
          responseData = {"status": "empty"};
        } else {

          responseData = {
            "status": "completed",
            "value": resultData.data!["paymentMethods"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};

    }
    return responseData;
  }


  // Paypal Api


  paypalPayNow(selectedAddressId) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult resultPaypal = await _client.mutate(
      MutationOptions(document: gql(addMutation.paypalPayNow()), variables: {
        'address': selectedAddressId,
      }),
    );
    return resultPaypal;
  }

  // cashfree api

  cashFreePayNow(selectedAddressId) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult resultCashFree = await _client.mutate(
      MutationOptions(document: gql(addMutation.cashfreePayNow()), variables: {
        'address': selectedAddressId,
      }),
    );
    return resultCashFree;
  }

  captureCashFree(data) async {
    try {
      var response = await dio.post(apiEndpoint.cashFreeEndpoint!, data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        
        return false;
      }
    } catch (e) {
      
      return false;
    }
  }

  // myOrder Api

  fetchMyOrders(page, skip, limit, search, sort, String status) async {
    Map responseData;

    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(
          MutationOptions(document: gql(addMutation.myOrders()), variables: {
            "store":store!.id
        // "page":page,
        // "skip":skip,
        // "limit":limit,
        // "search":search,
        // "sort":sort,
        // "status": status
      }));

      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null ||
            resultData.data!["myOrders"] == null ||
            resultData.data!["myOrders"]["data"].length == 0) {
          responseData = {"status": "empty"};
        } else {

          responseData = {
            "status": "completed",
            "value": resultData.data!["myOrders"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
    }
    return responseData;
  }

  orderItem(id) async {

    Map responseData;

    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(MutationOptions(
          document: gql(addMutation.orderItem()), variables: {"id": id}));

      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null || resultData.data!["orderItem"] == null) {
          responseData = {"status": "empty"};
        } else {
          responseData = {
            "status": "completed",
            "value": resultData.data!["orderItem"]
          };
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
     
    }
    return responseData;
  }

  Future<bool> returnItem(id, pid, reason, request, qty) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    try {
      await _client.mutate(
        MutationOptions(document: gql(addMutation.returnItem()), variables: {
          'orderId': id,
          'pId': pid,
          'reason': reason,
          'requestType': request,
          'qty': qty
        }),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // fcm token

  saveFcmToken(id, token, platform, deviceId, active) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(addMutation.saveFcmToken()), variables: {
        "id": id,
        "token": token,
        "platform": platform,
        "device_id": deviceId,
        "active": active
      }),
    );
    return result;
  }

  myToken(page, search, limit, sort) async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(addMutation.myTokens()),
      ),
    );
    if (result.hasException || result.data!["count"] == 0) {
      return false;
    }
    return true;
  }

  // Mega Menu

  fetchMegaMenu() async {
    Map responseData;
    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(MutationOptions(
        document: gql(addMutation.megamenu()),
        variables: {
          "store":store!.id
        }
      ));
      
      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        if (resultData.data == null ||
            resultData.data!["megamenu"].length == 0) {
          responseData = {"status": "empty"};
        } else {
          responseData = {"status": "completed", "value": resultData.data};
        }
      }
    } catch (e) {
      responseData = {"status": "error"};
      
    }
    return responseData;
  }

  // Review

  saveReview(id, pid, rating, message) async {
    Map responseData;

    try {
      GraphQLConfiguration graphQLConfiguration1 = GraphQLConfiguration();
      GraphQLClient _client1 = graphQLConfiguration1.clientToQuery();
      var resultData = await _client1.mutate(MutationOptions(
          document: gql(addMutation.saveReview()),
          variables: {
            "id": id,
            "pid": pid,
            "rating": rating,
            "message": message,
            "store":store!.id
          }));
      
      if (resultData.hasException) {
        responseData = {"status": "error"};
      } else {
        responseData = {
          "status": "completed",
        };
      }
    } catch (e) {
      responseData = {"status": "error"};
    }
    return responseData;
  }
}
