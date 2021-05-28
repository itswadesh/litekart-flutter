import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:anne/model/address.dart';
import 'package:anne/repository/address_repository.dart';
import 'package:anne/response_handler/addressResponse.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/utility/query_mutation.dart';
import '../utility/graphQl.dart';

class AddressViewModel with ChangeNotifier {

  QueryMutation addMutation = QueryMutation();
  Address _selectedAddress;
  var status = "loading";
  AddressResponse _addressResponse;
  final AddressRepository addressRepository = AddressRepository();
  Address get selectedAddress {
    return _selectedAddress;
  }

  AddressResponse get addressResponse {
    return _addressResponse;
  }

  fetchAddressData() async {
    var resultData = await addressRepository.fetchAddressData();
    status = resultData["status"];
    if(status=="completed"){
      _addressResponse = AddressResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  saveAddress(id, email, firstName, lastName, address, town, city, country,
      state, pin, phone) async {
     bool statusResponse;
     statusResponse = await addressRepository.saveAddress(id, email, firstName, lastName, address, town, city, country, state, pin, phone);
    await fetchAddressData();
    notifyListeners();
    return statusResponse;
  }

  deleteAddress(id) async {
    await addressRepository.deleteAddress(id);
    await fetchAddressData();
    notifyListeners();
  }

  selectAddress(address) {
    _selectedAddress = address;
    notifyListeners();
  }

  changeStatus(statusData) {
    status = statusData;
    notifyListeners();
  }


}
