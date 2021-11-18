class StoreData {

  String? id;
  String? currency;
  String? currencyCode;
  int? currencyDecimals;
  String? currencySymbol;
  StoreData({
    this.id,this.currency,this.currencyCode,this.currencyDecimals,this.currencySymbol
  });
  factory StoreData.fromJson(Map<String, dynamic> json)=>StoreData(
      id:json["id"]??"",
      //currency: json["currency"],
      currencyCode: json["currencyCode"]??"",
      currencyDecimals: json["currencyDecimals"]??0,
      currencySymbol: json["currencySymbol"]??""
  );
}