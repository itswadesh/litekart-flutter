import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:anne/model/user.dart';
import 'package:anne/repository/auth_repository.dart';
import 'package:anne/utility/shared_preferences.dart';
import 'package:anne/utility/query_mutation.dart';
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

  editProfile(phone, firstName, lastName, email, gender) async {
    await authRepository.editProfile(phone, firstName, lastName, email, gender);
    notifyListeners();
  }

  removeProfile() async{
    // await authRepository.removeProfile();
    _user = null;
    token = "";
    tempToken = "";
    notifyListeners();
  }
}
