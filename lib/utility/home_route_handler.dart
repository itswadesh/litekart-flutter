import 'package:anne/components/base/pk_dialog.dart';
import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/enum/home_card_layout.dart';
import 'package:anne/enum/pk_dialog_type.dart';
import 'package:anne/enum/tz_dialog_type.dart';
import 'package:anne/model/base/dynamic_routes.dart';
import 'package:anne/model/user.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/view_model/auth_view_model.dart';

// import 'package:url_launcher/url_launcher.dart';
import 'package:anne/values/route_path.dart' as routes;

import 'locator.dart';

Future<void> dynamicRouteHandler(DynamicRoute homeRoute) async {
  switch (homeRoute.type) {
    // case HomeRouteType.Url:
    //   return _handleUrlRoute(homeRoute);
    // break;
    case HomeRouteType.App:
      return _handleAppRoute(homeRoute);
      break;
    // case HomeRouteType.Api:
    //   return _handleApiRoute(homeRoute);
    default:
      return null;
  }
}

/*void _handleUrlRoute(DynamicRoute homeRoute) async {
  if (await canLaunch(homeRoute.target)) {
    launch(homeRoute.target, forceSafariVC: false);
  }
}

void _handleApiRoute(DynamicRoute homeRoute) async {
  final NavigationService _navigationService = locator<NavigationService>();
  PkDialog _dialog = PkDialog(
      _navigationService.navigationKey.currentContext, PkDialogType.progress);
  try {
    switch (homeRoute.target) {
      case 'list-master-class':
        _dialog.show();
        int courseId, trainerId;

        if (homeRoute.arguments != null) {
          courseId = homeRoute.arguments['courseId'] ?? null;
          trainerId = homeRoute.arguments['trainerId'] ?? null;
        }

        MasterClassRepository _repo = MasterClassRepository();
        ExploreResponse response = await _repo.getRecommendation(
            courseId: courseId, trainerId: trainerId);
        _dialog.close();
        await _navigationService.pushNamed(routes.ExploreRoute,
            args: {'resources': response.resources, 'showBackButton': true});
        break;
      default:
        return null;
    }
  } catch (e) {
    print('dynamic api route error $e');
    return null;
  }
}*/

_handleAppRoute(DynamicRoute homeRoute) async {
  try {
    final _navigationService = locator<NavigationService>();
    TzDialog tzDialog = TzDialog(
        _navigationService.navigationKey.currentContext,
        TzDialogType.notification,
        homeRoute.target);
    bool status = await tzDialog.show();
    if (status) {
      switch (homeRoute.target) {
        case routes.CartRoute:
          _navigationService.pushNamed(routes.CartRoute);
          break;
        case routes.ProductList:
          Map arguments;
          arguments = {
            "searchKey": homeRoute.arguments['searchKey'] ?? "",
            "category": homeRoute.arguments["category"] ?? "",
            "brandName": homeRoute.arguments["brandName"] ?? ""
          };
          _navigationService.pushNamed(routes.ProductList, args: arguments);
          break;
        case routes.MyProfile:
          User user = await ProfileModel().getProfile();
          if (user != null) {
            _navigationService.pushNamed(routes.MyProfile);
          } else {
            _navigationService.pushNamed(routes.LoginRoute);
          }
          break;
        case routes.ProductDetailRoute:
          String argument = homeRoute.arguments["id"];
          _navigationService.pushNamed(routes.ProductDetailRoute,
              args: argument);
          break;
        default:
          _navigationService.pushNamed(homeRoute.target);
          break;
      }
    } else {
      throw ('Dialog failed');
    }
  } catch (e) {
    throw (e);
  }
}
