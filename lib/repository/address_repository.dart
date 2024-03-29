import '../../utility/api_provider.dart';
import '../../utility/locator.dart';

class AddressRepository {
  ApiProvider? _apiProvider = locator<ApiProvider>();

  fetchAddressData() {
    return _apiProvider!.fetchAddressData();
  }

  saveAddress(id, email, firstName, lastName, address, city, country,
      state, pin, phone) {
    return _apiProvider!.saveAddress(id, email, firstName, lastName, address,
         city, country, state, pin, phone);
  }

  fetchLocation(lat,long){
    return _apiProvider!.fetchLocation(lat,long);
  }

  deleteAddress(id) {
    return _apiProvider!.deleteAddress(id);
  }

  fetchDataFromZip(zip) {
    return _apiProvider!.fetchDataFromZip(zip);
  }
}
