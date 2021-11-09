import '../../model/address.dart';

class CheckOutResponse {
  String? id;
  String? orderNo;
  String? otp;
  CheckOutAmount? amount;
  String? paymentOrderId;
  String? delivery;
  List<CheckOutData>? items;
  Address? address;
  String? createdAt;
  String? updatedAt;

  CheckOutResponse(
      {this.items,
      this.id,
      this.otp,
      this.amount,
      this.delivery,
      this.orderNo,
      this.paymentOrderId,
      this.createdAt,
      this.updatedAt,
      this.address});

  factory CheckOutResponse.fromJson(Map<String, dynamic> json) =>
      CheckOutResponse(
        id: json["id"],
        items: List<CheckOutData>.from(
            json["items"].map((x) => CheckOutData.fromJson(x))),
        orderNo: json["orderNo"],
        amount: CheckOutAmount.fromJson(json["amount"]),
        address: Address.fromJson(json["address"]),
        otp: json["otp"],
        delivery: json["delivery"],
        paymentOrderId: json["payment_order_id"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );
}

class CheckOutAmount {
  int? qty;
  double? subtotal;
  double? discount;
  double? shipping;
  int? total;

  CheckOutAmount(
      {this.qty, this.discount, this.subtotal, this.shipping, this.total});

  factory CheckOutAmount.fromJson(Map<String, dynamic> json) => CheckOutAmount(
      qty: json["qty"],
      discount: double.parse(json["discount"].toString()),
      subtotal: double.parse(json["subtotal"].toString()),
      shipping: double.parse(json["shipping"].toString()),
      total: json["total"]);
}

class CheckOutData {
  String? status;
  String? pid;
  String? name;
  String? slug;
  String? img;
  int? qty;
  double? price;
  String? brand;

  CheckOutData(
      {this.qty,
      this.pid,
      this.name,
      this.img,
      this.price,
      this.slug,
      this.status,
      this.brand});

  factory CheckOutData.fromJson(Map<String, dynamic> json) => CheckOutData(
      qty: json["qty"],
      price: double.parse(json["price"].toString()),
      pid: json["pid"],
      name: json["name"],
      img: json["imgCdn"],
      slug: json["slug"],
      status: json["status"],
      brand: json["brandName"] ?? "");
}
