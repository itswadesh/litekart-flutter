import 'package:flutter/cupertino.dart';
import '../../utility/locator.dart';
import '../../service/navigation/navigation_service.dart';
import '../../values/constant.dart';
import '../../values/route_path.dart' as routes;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
class OnboardingViewModel extends ChangeNotifier {
  final NavigationService? _navigationService = locator<NavigationService>();

  Future<void> getStarted() async {
    bool result = await _initChat();
    if (result) {
      if (settingData!.otpLogin!) { _navigationService!.pushNamedAndRemoveUntil(routes.LoginRoute);}
      else{
        _navigationService!.pushNamedAndRemoveUntil(routes.EmailLoginRoute);
      }
    }
  }

  Future<bool> _initChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(sharedPreferenceShownOnboarding, true);
  }

  Future<bool> forceSkip() async {
    bool result = await _initChat();
    if (result) {
       if (settingData!.otpLogin!) { _navigationService!.pushNamedAndRemoveUntil(routes.LoginRoute);}
                                  else{
                                    _navigationService!.pushNamedAndRemoveUntil(routes.EmailLoginRoute);
                                  }
    }
    return result;
  }
}
