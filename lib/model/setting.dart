class SettingData {
  bool liveCommerce;
  String id;
  bool otpLogin;
  SettingData({
    this.id,
    this.liveCommerce,
    this.otpLogin
});

  factory SettingData.fromJson(Map<String, dynamic> json)=>SettingData(
      id:json["id"],
      liveCommerce: json["liveCommerce"],
      otpLogin: json["otpLogin"]
      );
}