import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/enum/tz_dialog_type.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:flutter/cupertino.dart';
import '../../model/address.dart';
import '../../repository/address_repository.dart';
import '../../response_handler/addressResponse.dart';
import '../../utility/query_mutation.dart';

class AddressViewModel with ChangeNotifier {
  final NavigationService? _navigationService = locator<NavigationService>();
  QueryMutation addMutation = QueryMutation();
  Address? _selectedAddress;
  String? status = "loading";
  AddressResponse? _addressResponse;
  final AddressRepository addressRepository = AddressRepository();
  Address? get selectedAddress {
    return _selectedAddress;
  }
  late TzDialog _dialog;
  AddressViewModel() {
    _dialog = TzDialog(
        _navigationService!.navigationKey.currentContext, TzDialogType.progress);
  }

  AddressResponse? get addressResponse {
    return _addressResponse;
  }

  fetchAddressData() async {
    var resultData = await addressRepository.fetchAddressData();
    status = resultData["status"];
    if (status == "completed") {
      _addressResponse = AddressResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  saveAddress(id, email, firstName, lastName, address, city, country,
      state, pin, phone) async {
    _dialog.show();
    bool statusResponse;
    statusResponse = await addressRepository.saveAddress(id, email, firstName,
        lastName, address, city, country, state, pin, phone);
    await fetchAddressData();
    selectAddress(_addressResponse!.data![0]);
    _dialog.close();
    notifyListeners();
    return statusResponse;
  }

  deleteAddress(id) async {
    await addressRepository.deleteAddress(id);
    await fetchAddressData();
    if(id==_selectedAddress!.id){
    _selectedAddress = null;
    }
    notifyListeners();
  }

  selectAddress(address) {
    _selectedAddress = address;
    notifyListeners();
  }

  changeStatus(statusData) {
    _selectedAddress = null;
    status = statusData;
    notifyListeners();
  }
}
