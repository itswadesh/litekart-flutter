import '../../utility/api_provider.dart';
import '../../utility/locator.dart';

class AuthRepository {
  ApiProvider _apiProvider = locator<ApiProvider>();

  getProfile() {
    return _apiProvider.getProfile();
  }

  editProfile(phone, firstName, lastName, email, gender, image) {
    return _apiProvider.editProfile(phone, firstName, lastName, email, gender, image);
  }

  removeProfile() {
    return _apiProvider.removeProfile();
  }

}
