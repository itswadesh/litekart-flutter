import '../../utility/api_provider.dart';
import '../../utility/locator.dart';

class LoginRepository {
  ApiProvider? _apiProvider = locator<ApiProvider>();

  facebookMobileLogin(accessToken) {
    return _apiProvider!.facebookMobileLogin(accessToken);
  }

  googleOneTap(accessToken){
    return _apiProvider!.googleOneTap(accessToken);
  }

}
