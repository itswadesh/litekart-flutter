class SettingData {
  bool liveCommerce;

  SettingData({
    this.liveCommerce
});

  factory SettingData.fromJson(Map<String, dynamic> json)=>SettingData(
      liveCommerce: json["liveCommerce"]
      );
}