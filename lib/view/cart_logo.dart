import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/view_model/cart_view_model.dart';
import 'package:anne/values/route_path.dart' as routes;

class CartLogo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartLogo();
  }
}

class _CartLogo extends State<CartLogo> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: Consumer<CartViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.status == "loading") {
        Provider.of<CartViewModel>(context, listen: false).fetchCartData();
      }
      return InkWell(
          onTap: () {
            _navigationService.pushNamed(routes.CartRoute);
          },
          child: Padding(
              padding: const EdgeInsets.only(right: 14, left: 14),
              child: Center(
                  child: Stack(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: ScreenUtil().setWidth(28),
                    color: Colors.black54,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(12), 0, 0, 0),
                      width: ScreenUtil().radius(15),
                      height: ScreenUtil().radius(15),
                      decoration: new BoxDecoration(
                        color: Color(0xffbb8738),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "${value.cartCount}",
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: ScreenUtil().setSp(12)),
                        ),
                      ))
                ],
              ))));
    }));
  }
}
