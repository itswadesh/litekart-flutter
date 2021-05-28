
import 'package:anne/utility/api_provider.dart';
import 'package:anne/utility/locator.dart';

class AddressRepository {
  ApiProvider _apiProvider = locator<ApiProvider>();

   fetchAddressData() {
    return _apiProvider.fetchAddressData();
  }

  saveAddress(id, email, firstName, lastName, address, town, city, country,
      state, pin, phone) {
    return _apiProvider.saveAddress(id, email, firstName, lastName, address, town, city, country, state, pin, phone);
  }

  deleteAddress(id) {
    return _apiProvider.deleteAddress(id);
  }

  fetchDataFromZip(zip){
     return _apiProvider.fetchDataFromZip(zip);
  }
}