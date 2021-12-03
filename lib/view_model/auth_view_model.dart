import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/enum/tz_dialog_type.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/utility/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../../model/user.dart';
import '../../repository/auth_repository.dart';
import '../../utility/query_mutation.dart';
import '../utility/graphQl.dart';

class ProfileModel extends ChangeNotifier {
 // final NavigationService? _navigationService = locator<NavigationService>();
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  User? _user;
  // late TzDialog _dialog;
  bool editStatus = false;
  AuthRepository authRepository = AuthRepository();
  User? get user {
    return _user;
  }

  // ProfileModel() {
  //   _dialog = TzDialog(
  //       _navigationService!.navigationKey.currentContext, TzDialogType.progress);
  // }

   getProfile() async {
    // _dialog.show();
    _user = await authRepository.getProfile();
    // _dialog.close();
    notifyListeners();
  }

  Future<User?> returnProfile() async {
    _user = await authRepository.getProfile();
    return _user;
  }

  editProfile(phone, firstName, lastName, email, gender, image) async {
    editStatus = false;
  bool response =  await authRepository.editProfile(phone, firstName, lastName, email, gender, image);
   if(response){
     editStatus = true;
   }
    notifyListeners();
  }

  removeProfile() async {
    // await authRepository.removeProfile();
    _user = null;
    token = "";
    tempToken = "";
    await deleteCookieFromSF();
    notifyListeners();
  }
}
