import 'package:flutter/cupertino.dart';
import '../../model/user.dart';
import '../../repository/auth_repository.dart';
import '../../utility/query_mutation.dart';
import '../utility/graphQl.dart';

class ProfileModel extends ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  User _user;
  AuthRepository authRepository = AuthRepository();
  User get user {
    return _user;
  }

  Future<User> getProfile() async {
    _user = await authRepository.getProfile();
    notifyListeners();
    return _user;
  }

  editProfile(phone, firstName, lastName, email, gender, image) async {
    await authRepository.editProfile(phone, firstName, lastName, email, gender, image);
    notifyListeners();
  }

  removeProfile() async {
    // await authRepository.removeProfile();
    _user = null;
    token = "";
    tempToken = "";
    notifyListeners();
  }
}
