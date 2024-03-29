import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../model/setting.dart';
import '../../repository/settings_repository.dart';
import '../../utility/query_mutation.dart';

class SettingViewModel with ChangeNotifier {
  String? status = "loading";
  QueryMutation addMutation = QueryMutation();
  SettingsRepository settingsRepository = SettingsRepository();
  SettingData? _settingResponse;
  SettingData? get settingResponse {
    return _settingResponse;
  }

  Future<void> fetchSettings() async {
    var resultData = await settingsRepository.settings();
    status = resultData["status"];
    if (status == "completed") {
      _settingResponse = SettingData.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  fetchSettingData() async {
    var resultData = await settingsRepository.settings();
    status = resultData["status"];
    if (status == "completed") {

      _settingResponse = SettingData.fromJson(resultData["value"]);
      return _settingResponse;
    }
    return null;
    notifyListeners();
  }

  changeStatus(statusData) {
    status = statusData;
  }

}
