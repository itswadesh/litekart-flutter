class CashFreeResponse {
  String? appId;
  String? orderId;
  String? orderAmount;
  String? orderCurrency;
  String? orderNote;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? returnUrl;
  String? notifyUrl;
  String? signature;
  String? stage;
  String? url;
  String? token;
  CashFreeResponse(
      {this.url,
      this.appId,
      this.customerEmail,
      this.customerName,
      this.customerPhone,
      this.notifyUrl,
      this.orderAmount,
      this.orderCurrency,
      this.orderId,
      this.orderNote,
      this.returnUrl,
      this.signature,
      this.stage,
      this.token});

  factory CashFreeResponse.fromJson(Map<String, dynamic> json) =>
      CashFreeResponse(
          appId: json["appId"],
          orderId: json["orderId"],
          orderAmount: json["orderAmount"].toString(),
          orderCurrency: json["orderCurrency"],
          orderNote: json["orderNote"],
          customerName: json["customerName"],
          customerEmail: json["customerEmail"],
          customerPhone: json["customerPhone"],
          returnUrl: json["returnUrl"],
          notifyUrl: json["notifyUrl"],
          signature: json["signature"],
          stage: json["stage"],
          url: json["url"],
          token: json["token"]);
}
