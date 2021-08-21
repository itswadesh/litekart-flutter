import 'package:anne/view/menu.dart';
import 'package:anne/view_model/menu_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../response_handler/brandResponse.dart';
import '../../response_handler/checkOutResponse.dart';
import '../../values/route_path.dart' as routes;
import '../../view/add_review_page.dart';
import '../../view/brand_page.dart';
import '../../view/cart.dart';
import '../../view/checkout.dart';
import '../../view/common/login.dart';
import '../../view/common/onboarding.dart';
import '../../view/menu/manage_address.dart';
import '../../view/order_confirm.dart';
import '../../view/order_tracking.dart';
import '../../view/product_detail.dart';
import '../../view/product_list.dart';
import '../../view/profile/profilePage.dart';
import '../../view/return.dart';
import '../../view/search.dart';
import '../../view/zoom_image.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  debugPrint('Route Name => ${settings.name}');
  debugPrint('Route Arguments  => ${settings.arguments}');
  String productId;
  var productList;
  var orderTrackData;
  var returnData;
  CheckOutResponse checkoutResponse;
  var arguments = settings.arguments;
  if (settings.name == routes.ProductDetailRoute ||
      settings.name == routes.AddReviewRoute) {
    productId = settings.arguments;
  }
  if (settings.name == routes.OrderConfirm) {
    checkoutResponse = settings.arguments;
  }

  if (settings.name == routes.OrderTrack) {
    orderTrackData = settings.arguments as Map<String, dynamic>;
  }
  if (settings.name == routes.ReturnPageRoute) {
    returnData = settings.arguments as Map<String, dynamic>;
  }
  if (settings.name == routes.ProductList) {
    print("here");
    print(settings.arguments.toString());
    productList = settings.arguments as Map<String, dynamic>;
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
      return MaterialPageRoute(
          builder: (context) => Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(0);
                  return Menu(model);
                },
              ));
      break;
    // case routes.SplashRoute:
    //   return MaterialPageRoute(builder: (context) => SplashScreen());
    //   break;
    case routes.ProductDetailRoute:
      return MaterialPageRoute(builder: (context) => ProductDetail(productId));
      break;
    case routes.OrderConfirm:
      return MaterialPageRoute(
          builder: (context) => OrderConfirm(checkoutResponse));
      break;
    case routes.OrderTrack:
      return MaterialPageRoute(
          builder: (context) => OrderTracking(orderTrackData["id"],
              orderTrackData["items"], orderTrackData["address"]));
      break;
    case routes.ProductList:
      return MaterialPageRoute(
          builder: (context) => ProductList(
              productList["searchKey"],
              productList["category"],
              productList["brandName"],
              productList["parentBrand"],
              productList["brand"],
              productList["urlLink"]));
      break;
    case routes.ReturnPageRoute:
      return MaterialPageRoute(
          builder: (context) => ReturnPage(
              returnData["id"], returnData["pid"], returnData["qty"]));
      break;
    case routes.CartRoute:
      return MaterialPageRoute(builder: (context) => Cart());
      break;
    case routes.AddReviewRoute:
      return MaterialPageRoute(builder: (context) => AddReviewPage(productId));
      break;
    case routes.ZoomImageRoute:
      Map<String, dynamic> zoomArguments =
          settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (context) =>
              ZoomImage(zoomArguments['imageLinks'], zoomArguments['index']));
      break;
    case routes.ProfileInfoRoute:
      return MaterialPageRoute(builder: (context) => ProfilePage());
      break;
    case routes.MyProfile:
      return MaterialPageRoute(
          builder: (context) => Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(4);
                  return Menu(model);
                },
              ));
      break;
    case routes.ManageAddress:
      return MaterialPageRoute(builder: (context) => ManageAddress());
      break;
    case routes.ManageOrder:
      return MaterialPageRoute(
          builder: (context) => Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(2);
                  return Menu(model);
                },
              ));
      break;
    case routes.Wishlist:
      return MaterialPageRoute(
          builder: (context) => Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(3);
                  return Menu(model);
                },
              ));
      break;
    case routes.CheckOut:
      return MaterialPageRoute(builder: (context) => Checkout());
      break;
    case routes.SearchPage:
      return MaterialPageRoute(builder: (context) => SearchPage());
      break;
    case routes.MegaMenuRoute:
      return MaterialPageRoute(
          builder: (context) => Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(1);
                  return Menu(model);
                },
              ));
      break;
    case routes.BrandPage:
      return MaterialPageRoute(
          builder: (context) =>
              BrandPage(brand: data['brandData'] as BrandData));
      break;
    default:
      return errorPageRoute(settings);
  }
}

MaterialPageRoute<dynamic> errorPageRoute(RouteSettings settings) {
  if (kReleaseMode) {
    return MaterialPageRoute(
        builder: (context) => Consumer<MenuViewModel>(
              builder: (context, model, view) {
                model.updateIndex(0);
                return Menu(model);
              },
            ));
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
