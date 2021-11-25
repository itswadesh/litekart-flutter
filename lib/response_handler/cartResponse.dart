import '../main.dart';

class CartResponse {
  int? qty;
  double? subtotal;
  DiscountModel? discount;
  String? shipping;
  double? total;
  int? tax;
  List<CartData>? items;

  CartResponse(
      {this.items,
      this.qty,
      this.subtotal,
      this.discount,
      this.tax,
      this.total,
      this.shipping});

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
      items:
          List<CartData>.from(json["items"].map((x) => CartData.fromJson(x))),
      qty: json["qty"]??0,
      discount: DiscountModel.fromJson(json["discount"]),
      shipping: (double.parse(json["shipping"]["charge"].toString()).toStringAsFixed(store!.currencyDecimals!)) ,
      tax: json["tax"] ?? 0,
      total: double.parse(double.parse(json["total"].toString()).toStringAsFixed(store!.currencyDecimals!)),
      subtotal: double.parse(double.parse(json["subtotal"].toString()).toStringAsFixed(store!.currencyDecimals!)));
}

class CartData {
  String? pid;
  String? slug;
  String? name;
  double? price;
  String? img;
  String? tracking;
  String? options;
  int? qty;
  String? brand;

  CartData(
      {this.name,
      this.img,
      this.pid,
      this.slug,
      this.price,
      this.options,
      this.tracking,
      this.qty,
      this.brand});

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
      name: json["name"],
      img: json["imgCdn"],
      pid: json["pid"],
      slug: json["slug"],
      options: json["options"],
      tracking: json["tracking"],
      price: double.parse(double.parse(json["price"].toString()).toStringAsFixed(store!.currencyDecimals!)),
      qty: json["qty"],
      brand: json["brand"] != null ? json["brand"]["name"] : " ");
}

class DiscountModel {
  String? code;
  int? value;
  String? text;
  double? amount;

  DiscountModel({this.value, this.text, this.code, this.amount});

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
      code: json["code"],
      value: json["value"],
      text: json["text"],
      amount: double.parse(double.parse(json["amount"].toString()).toStringAsFixed(store!.currencyDecimals!)));
}

class ShippingModel {
  double? charge;

  ShippingModel({this.charge});

  factory ShippingModel.fromJson(Map<String, dynamic> json) =>
      ShippingModel(charge: double.parse(json["charge"].toString()));
}

class TaxModel {
  double? cgst;
  double? sgst;
  double? igst;

  TaxModel({this.cgst, this.igst, this.sgst});

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
      cgst: double.parse(double.parse(json["cgst"].toString()).toStringAsFixed(store!.currencyDecimals!)),
      sgst: double.parse(double.parse(json["sgst"].toString()).toStringAsFixed(store!.currencyDecimals!)),
      igst: double.parse(double.parse(json["igst"].toString()).toStringAsFixed(store!.currencyDecimals!)));
}
