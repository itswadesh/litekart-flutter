import 'package:anne/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../view_model/cart_view_model.dart';
import '../../values/route_path.dart' as routes;

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
        return
          // Padding(
          // // padding: const EdgeInsets.only(right: 14, left: 14),
          // child:
          Center(
              child:  Icon(
          Icons.shopping_cart,
          size: 22,
          color: Color(0xff616161),
        //)
          ));
      }
      return InkWell(
        onTap: () {
          _navigationService.pushNamed(routes.CartRoute);
        },
        child:
        //Padding(
          // padding: const EdgeInsets.only(right: 14, left: 14),
        //  child:
        Center(
            child: Stack(
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 22,
                  color: Color(0xff616161),
                ),
                value.cartCount > 0
                    ? Positioned(
                      left: 7, top: 0,
                      child: Container(
                          width: ScreenUtil().radius(12),
                          height: ScreenUtil().radius(12),
                          decoration: new BoxDecoration(
                            color: AppColors.primaryElement,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${value.cartCount}",
                              style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontSize: ScreenUtil().setSp(9)),
                            ),
                          ),
                        ),
                    )
                    : SizedBox.shrink()
              ],
            ),
          ),
        //),
      );
    }));
  }
}
