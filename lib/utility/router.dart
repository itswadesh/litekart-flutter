import 'package:anne/response_handler/channelResponse.dart';
import 'package:anne/view/common/emailLogin.dart';
import 'package:anne/view/common/register.dart';
import 'package:anne/view/liveStreamPages/joinLiveStreamPage.dart';
import 'package:anne/view/menu.dart';
import 'package:anne/view/menu/wishlist.dart';
import 'package:anne/view/profile/profileEditPage.dart';
import 'package:anne/view/scheduleVideoCalls/myScheduleDemoListPage.dart';
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
import '../main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {

  String? productId;
  var productList;
  var orderTrackData;
  var returnData;
  CheckOutResponse? checkoutResponse;
  var arguments = settings.arguments;
  if (settings.name == routes.ProductDetailRoute ||
      settings.name == routes.AddReviewRoute) {
    productId = settings.arguments as String?;
  }


  if (settings.name == routes.OrderConfirm) {
    checkoutResponse = settings.arguments as CheckOutResponse?;
  }

  if (settings.name == routes.OrderTrack) {
    orderTrackData = settings.arguments as Map<String, dynamic>?;
  }
  if (settings.name == routes.ReturnPageRoute) {
    returnData = settings.arguments as Map<String, dynamic>?;
  }
  if (settings.name == routes.ProductList) {

    productList = settings.arguments as Map<String, dynamic>?;
  }
  Map? data;
  if (arguments is Map) {
    data = settings.arguments as Map<String, dynamic>?;
  }

  switch (settings.name) {
    case routes.LoginRoute:
        return ScaleRoute(page: Login());
      break;
    case routes.EmailLoginRoute:
      return ScaleRoute(page: EmailLogin());
      break;
    case routes.RegisterRoute:
      return ScaleRoute(page: Register());
      break;
    case routes.OnboardingRoute:
      return ScaleRoute(page: Onboarding());
      break;
    case routes.HomeRoute:
      return ScaleRoute(page: Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(0);
                  return Menu(model);
                },
              ));
      break;
    // case routes.SplashRoute:
    //   return ScaleRoute(page: SplashScreen());
    //   break;
    case routes.ProductDetailRoute:
      return ScaleRoute(page: ProductDetail(productId));
     // return ScaleRoute(page: ProductDetail(productId));
      break;
    case routes.OrderConfirm:
      return ScaleRoute(page: OrderConfirm(checkoutResponse));
      break;
    case routes.LiveStreamPlayer:
      return ScaleRoute(page: JoinLiveStreamPlayerPage(settings.arguments as ChannelData?));
      break;
    case routes.OrderTrack:
      return ScaleRoute(page: OrderTracking(orderTrackData["id"],
              orderTrackData["items"], orderTrackData["address"]));
      break;
    case routes.ProductList:
      return ScaleRoute(page: ProductList(
              productList["searchKey"],
              productList["category"],
              productList["brandName"],
              productList["parentBrand"],
              productList["brand"],
              productList["urlLink"]));
      break;
    case routes.ReturnPageRoute:
      return ScaleRoute(page: ReturnPage(
              returnData["id"], returnData["pid"], returnData["qty"]));
      break;
    case routes.CartRoute:
      return ScaleRoute(page: Cart());
      break;
    case routes.AddReviewRoute:
      return ScaleRoute(page: AddReviewPage(productId));
      break;
    case routes.ZoomImageRoute:
      Map<String, dynamic> zoomArguments =
          settings.arguments as Map<String, dynamic>;
      return ScaleRoute(page:
              ZoomImage(zoomArguments['imageLinks'], zoomArguments['index']));
      break;
    case routes.ProfileEditRoute:
      return ScaleRoute(page: ProfileEdit());
      //return ScaleRoute(page: ProfileEdit());
      break;
    case routes.MyProfile:
      return ScaleRoute(page: Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(4);
                  return Menu(model);
                },
              ));
      break;
    case routes.ManageAddress:
      return ScaleRoute(page: ManageAddress());
      break;
    case routes.ScheduleDemoList:
      return ScaleRoute(page: MyScheduleDemoListPage());
      break;
    case routes.ManageOrder:
      return ScaleRoute(page: Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(3);
                  return Menu(model);
                },
              ));
      break;
    case routes.LiveCommerce:
      return ScaleRoute(page: Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(2);
                  return Menu(model);
                },
              ));
      break;
    case routes.Wishlist:
      // return ScaleRoute(page: Consumer<MenuViewModel>(
      //   builder: (context, model, view) {
      //     model.updateIndex(2);
      //     return Menu(model);
      //   },
      // ));
      return ScaleRoute(page: Wishlist());
      break;
    case routes.CheckOut:
      return ScaleRoute(page: Checkout());
      break;
    case routes.SearchPage:
      return ScaleRoute(page: SearchPage());
      break;
    case routes.MegaMenuRoute:
      return ScaleRoute(page: Consumer<MenuViewModel>(
                builder: (context, model, view) {
                  model.updateIndex(1);
                  return Menu(model);
                },
              ));
      break;
    case routes.BrandPage:
      return ScaleRoute(page:
              BrandPage(brand: data!['brandData'] as BrandData?));
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


class ScaleRoute extends PageRouteBuilder {
  final Widget? page;
  ScaleRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page!,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        ),
  );
}