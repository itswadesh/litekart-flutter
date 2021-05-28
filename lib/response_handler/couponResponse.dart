class CouponResponse {
  int count;
  int page;
  int pageSize;
  List<CouponData> data;

  CouponResponse({this.count, this.page, this.data, this.pageSize});

  factory CouponResponse.fromJson(Map<String, dynamic> json) => CouponResponse(
        count: json["count"],
        page: json["page"],
        pageSize: json["pageSize"],
        data: List<CouponData>.from(
            json["data"].map((x) => CouponData.fromJson(x))),
      );
}

class CouponData {
  bool active;
  String createdAt;
  String updatedAt;
  String id;
  String code;
  int value;
  String type;
  String info;
  String msg;
  String text;
  String terms;
  String color;
  int minimumCartValue;
  int maxAmount;
  String validFromDate;
  String validToDate;

  CouponData({
    this.id,
    this.value,
    this.text,
    this.color,
    this.createdAt,
    this.updatedAt,
    this.active,
    this.code,
    this.type,
    this.info,
    this.maxAmount,
    this.minimumCartValue,
    this.msg,
    this.terms,
    this.validFromDate,
    this.validToDate,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) => CouponData(
      id: json["id"],
      value: json["value"],
      type: json["type"],
      text: json["text"],
      color: json["color"],
      code: json["code"],
      info: json["info"],
      maxAmount: json["maxAmount"],
      minimumCartValue: json["minimumCartValue"],
      msg: json["msg"],
      terms: json["terms"],
      validFromDate: json["validFromDate"],
      validToDate: json["validToDate"],
      active: json["active"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);
}
