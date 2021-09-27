class SettingData {
  bool liveCommerce;
  String id;
  SettingData({
    this.id,
    this.liveCommerce
});

  factory SettingData.fromJson(Map<String, dynamic> json)=>SettingData(
      id:json["id"],
      liveCommerce: json["liveCommerce"]
      );
}