import 'package:anne/view/video_talk/video_talk_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:anne/response_handler/checkOutResponse.dart';
import 'package:anne/values/route_path.dart' as routes;
import 'package:anne/view/cart.dart';
import 'package:anne/view/checkout.dart';
import 'package:anne/view/common/login.dart';
import 'package:anne/view/common/onboarding.dart';
import 'package:anne/view/home.dart';
import 'package:anne/view/menu/manage_address.dart';
import 'package:anne/view/menu/manage_order.dart';
import 'package:anne/view/menu/my_profile.dart';
import 'package:anne/view/menu/wishlist.dart';
import 'package:anne/view/order_confirm.dart';
import 'package:anne/view/product_detail.dart';
import 'package:anne/view/product_list.dart';
import 'package:anne/view/play_stream/play_stream_page.dart';
import 'package:anne/view/profile/profilePage.dart';
import 'package:anne/view/search.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  debugPrint('Route Name => ${settings.name}');
  debugPrint('Route Arguments  => ${settings.arguments}');
  String productId;
  var productList;
  var streamArgs;
  CheckOutResponse checkoutResponse;
  var arguments = settings.arguments;
  if(settings.name==routes.ProductDetailRoute){
    productId = settings.arguments;
  }
  if(settings.name==routes.OrderConfirm){
    checkoutResponse = settings.arguments;
  }
  if(settings.name==routes.ProductList){
    productList =settings.arguments as Map<String, dynamic>;
  }

  if(settings.name == routes.StreamPlay){
    streamArgs = settings.arguments as Map<String, dynamic>;
  }
  Map data;
  if (arguments is Map) {
    data = settings.arguments as Map<String, dynamic>;
  }

  switch (settings.name) {
    case routes.LoginRoute:
      return MaterialPageRoute(builder: (context) => Login());
      break;
    case routes.OnboardingRoute:
      return MaterialPageRoute(builder: (context) => Onboarding());
      break;
    case routes.HomeRoute:
      return MaterialPageRoute(builder: (context) => Home());
      break;
    // case routes.SplashRoute:
    //   return MaterialPageRoute(builder: (context) => SplashScreen());
    //   break;
    case routes.ProductDetailRoute:
      print("here is the id : "+productId);
      return MaterialPageRoute(builder: (context)=>ProductDetail(productId));
      break;
    case routes.OrderConfirm:
      return MaterialPageRoute(builder: (context)=>OrderConfirm(checkoutResponse));
      break;
    case routes.ProductList:
      return MaterialPageRoute(builder: (context)=>ProductList(productList["searchKey"],productList["category"],productList["brandName"]));
      break;
    case routes.CartRoute:
      return MaterialPageRoute(builder: (context) => Cart());
      break;
    case routes.ProfileInfoRoute:
      return MaterialPageRoute(builder: (context) => ProfilePage());
      break;
    case routes.MyProfile:
      return MaterialPageRoute(builder: (context) => MyProfile());
      break;
    case routes.ManageAddress:
      return MaterialPageRoute(builder: (context) => ManageAddress());
      break;
    case routes.ManageOrder:
      return MaterialPageRoute(builder: (context) => ManageOrder());
      break;
    case routes.Wishlist:
      return MaterialPageRoute(builder: (context) => Wishlist());
      break;
    case routes.CheckOut:
      return MaterialPageRoute(builder: (context) => Checkout());
      break;
    case routes.SearchPage:
      return MaterialPageRoute(builder: (context) => SearchPage());
      break;
    case routes.StreamList:
      return MaterialPageRoute(builder: (context) => PlayStreamPage(streamArgs["roomId"],streamArgs["screenWidthPx"],streamArgs["screenHeightPx"]));
      break;
    case routes.VideoTalk:
      return MaterialPageRoute(builder: (context) => VideoTalkPage());
      break;
    default:
      return errorPageRoute(settings);
  }
}

MaterialPageRoute<dynamic> errorPageRoute(RouteSettings settings) {
  if (kReleaseMode) {
    return MaterialPageRoute(builder: (context) => Home());
  } else {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('No path for ${settings.name}'),
        ),
      ),
    );
  }
}
