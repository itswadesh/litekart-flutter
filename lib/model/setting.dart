class SettingData {
  bool liveCommerce;
  String id;
  bool otpLogin;
  String stripePublishableKey;
  String brainTreePublicKey;
  String googleClientId;
  SettingData({
    this.id,
    this.liveCommerce,
    this.otpLogin,
    this.stripePublishableKey,
    this.brainTreePublicKey,
    this.googleClientId
});

  factory SettingData.fromJson(Map<String, dynamic> json)=>SettingData(
      id:json["id"],
      liveCommerce: json["liveCommerce"],
      otpLogin: json["otpLogin"],
      stripePublishableKey: json["stripePublishableKey"],
      brainTreePublicKey : json["brainTreePublicKey"],
      googleClientId: json["GOOGLE_CLIENT_ID"]
      );
}