import 'package:anne/utility/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../../model/user.dart';
import '../../repository/auth_repository.dart';
import '../../utility/query_mutation.dart';
import '../utility/graphQl.dart';

class ProfileModel extends ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  User _user;
  bool editStatus = false;
  AuthRepository authRepository = AuthRepository();
  User get user {
    return _user;
  }

   getProfile() async {
    _user = await authRepository.getProfile();
    notifyListeners();
  }

  Future<User> returnProfile() async {
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
