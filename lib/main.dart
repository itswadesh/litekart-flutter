import 'dart:async';
import 'dart:io';
import 'package:anne/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../../service/firebase/push_notification_service.dart';
import '../../utility/locator.dart';
import '../../values/colors.dart';
import '../../view_model/address_view_model.dart';
import '../../view_model/auth_view_model.dart';
import '../../view_model/brand_view_model.dart';
import '../../view_model/cart_view_model.dart';
import '../../view_model/category_view_model.dart';
import '../../view_model/list_details_view_model.dart';
import '../../view_model/megamenu_view_model.dart';
import '../../view_model/product_detail_view_model.dart';
import '../../view_model/product_view_model.dart';
import '../../model/user.dart';
import '../../utility/graphQl.dart';
import '../../view_model/rating_view_model.dart';
import '../../view_model/wishlist_view_model.dart';
import 'service/navigation/navigation_service.dart';
import '../../utility/router.dart' as router;
import '../../values/route_path.dart' as routes;
import 'utility/shared_preferences.dart';
import 'view_model/banner_view_model.dart';
import 'package:firebase_core/firebase_core.dart';

import 'view_model/manage_order_view_model.dart';
import 'view_model/menu_view_model.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..maxConnectionsPerHost = 5
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await Firebase.initializeApp();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  bool showOnboarding = await showOnBoardingStatus();
  setupLocator();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  token = await getCookieFromSF();
  User user = await ProfileModel().returnProfile();
  print(user);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) async {
    runApp(
      GraphQLProvider(
          client: graphQLConfiguration.initailizeClient(),
          child: CacheProvider(child: Main(showOnboarding ?? true, user))),
    );
  });
}

class Main extends StatefulWidget {
  final bool showOnboarding;
  final User user;

  Main(this.showOnboarding, [this.user]);

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<Main> {
  String _initialRoute;
  bool fcmUpdate = false;
  Timer timer, fcmTimer;
  PushNotificationService pushNotificationService =
      locator<PushNotificationService>();

  @override
  void initState() {
    if (widget.showOnboarding) {
      _initialRoute = routes.OnboardingRoute;
    } else {
      if (widget.user != null) {
        _initialRoute = routes.HomeRoute;
      } else {
        _initialRoute = routes.LoginRoute;
      }
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateFcmToken();
    });
  }

  Future<void> updateFcmToken() async {
    if (!fcmUpdate) {
      // fcmTimer = Timer.periodic(Duration(hours: 1), (Timer t) async {
      await pushNotificationService.initialise();
      if (mounted) {
        // if (fcmUpdate) {
        //   fcmTimer.cancel();
        // }
      }
      // });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    fcmTimer?.cancel();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(414, 746),
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: ProfileModel()),
          ChangeNotifierProvider.value(value: MenuViewModel()),
          ChangeNotifierProvider.value(value: CategoryViewModel()),
          ChangeNotifierProvider.value(value: ListDealsViewModel()),
          ChangeNotifierProvider.value(value: BannerViewModel()),
          ChangeNotifierProvider.value(value: ProductViewModel()),
          ChangeNotifierProvider.value(value: CartViewModel()),
          ChangeNotifierProvider.value(value: BrandViewModel()),
          ChangeNotifierProvider.value(value: AddressViewModel()),
          ChangeNotifierProvider.value(value: WishlistViewModel()),
          ChangeNotifierProvider.value(value: ProductDetailViewModel()),
          ChangeNotifierProvider.value(value: MegaMenuViewModel()),
          ChangeNotifierProvider.value(value: OrderViewModel()),
          ChangeNotifierProvider.value(value: RatingViewModel()),
          ChangeNotifierProvider.value(value: SettingViewModel()),
        ],
        child: MaterialApp(
          initialRoute: _initialRoute,
          title: 'Anne',
          theme: ThemeData(
            fontFamily: 'Inter',
            primarySwatch: AppColors.primaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: SplashScreen(),
          onGenerateRoute: router.generateRoute,
          navigatorKey: locator<NavigationService>().navigationKey,
        ),
      ),
    );
  }
}
