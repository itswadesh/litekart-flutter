import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../bloc/connectivity_bloc.dart';
import 'package:provider/provider.dart';
import '../../service/event/tracking.dart';
import '../../values/colors.dart';
import '../../values/event_constant.dart';
import '../../values/functions.dart';
import '../../view_model/onboarding_view_model.dart';
import 'internet.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  ConnectivityBloc _connectivityBloc = ConnectivityBloc.instance;
  double aspectRatio;
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  double textSizeReduceFactor = 0;

  @override
  void initState() {
    /*initChat();*/
    Tracking(event: EVENT_ONBOARDING);
    super.initState();
    _connectivityBloc.initialise();
  }

  @override
  void dispose() {
    _connectivityBloc.dispose();
    super.dispose();
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 10.0,
      width: isActive ? 30.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0X4d000000) : Color(0X4d000000),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    aspectRatio = getAspectRatio(context);
    if (MediaQuery.of(context).size.height < 800) {
      textSizeReduceFactor = 2;
    }

    return StreamBuilder<ConnectivityResult>(
      builder: (_, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot?.data == ConnectivityResult.none) {
          return Internet();
        } else {
          return getBody();
        }
      },
      stream: _connectivityBloc.connectionStream,
    );
  }

  Widget getBody() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => OnboardingViewModel(),
      child: Consumer<OnboardingViewModel>(
        builder: (context, model, child) => WillPopScope(
            child: Scaffold(
              body: AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent
    ),
    child: SafeArea(
    child: Container(
                  decoration: BoxDecoration(color: AppColors.primaryBackground),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.84,
                          child: PageView(
                            physics: ClampingScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            children: <Widget>[
                              getScreens(
                                  image: "assets/images/onboarding_one.png",
                                  title: "Discover",
                                  description:
                                      "Your favourite products at an amazing discount. Refresh the latest fashion trends. Explore a new way to shop."),
                              getScreens(
                                  image: "assets/images/onboarding_two.png",
                                  title: "Purchase",
                                  description:
                                      "Multiple payment options Get Biggest deals on Global Brands. Tops brands at the best price. Delight in the best offer online."),
                              getScreens(
                                  image: "assets/images/onboarding_three.png",
                                  title: "Delivery",
                                  description:
                                      "Anywhere with easy checkouts and quick delivery from our door to yours, Fast and no contact delivery at your doorsteps"),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildPageIndicator(),
                        ),
                      ],
                    ),
                  ),
                )),
              ),
              bottomSheet: _currentPage == _numPages - 1
                  ? InkWell(
                      onTap: () {
                        model.getStarted();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: double.infinity,
                        color: AppColors.primaryElement,
                        child: Center(
                          child: Text(
                            'Get started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Text(''),
            ),
            onWillPop: () async {
              return model.forceSkip();
            }),
      ),
    );
  }

  Widget getScreens(
      {@required String image,
      @required String title,
      @required String description}) {
    return Padding(
      padding: EdgeInsets.only(top: 40, right: 40, left: 40, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Image(
                image: AssetImage(
                  '$image',
                ),
                height: MediaQuery.of(context).size.height * 0.40,
                width: MediaQuery.of(context).size.width * 0.80,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Center(
            child: Text(
              "$title",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 30 - textSizeReduceFactor,
                height: 1.36667,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Center(
            child: Opacity(
              opacity: 0.7,
              child: Text(
                "$description",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16 - textSizeReduceFactor,
                  height: 1.5,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget shadowImage() {
    return Container(
      width: 250.0,
      height: 22.0,
      decoration: BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Color(0x26000000),
            blurRadius: 15.0,
          ),
        ],
      ),
    );
  }
}
