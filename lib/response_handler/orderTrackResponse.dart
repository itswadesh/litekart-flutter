
class OrderTrackResponse{
 String? id;
 String? orderId;
 String? status;
 String? pid;
 String? posInvoiceNo;
 String? itemOrderNo;
 String? name;
 String? slug;
 String? img;
 String? tracking;
 double? shippingCharge;
 double? price;
 int? qty;
 int? tax;
 String? brandName;
 String? brandImg;
 String? size;
 String? color;
 String? trackingId;
 String? returnTrackingId;
 String? courierName;
 String? returnCourierName;
 int? days;
 String? type;
  //order level info
 String? orderNo;
 String? otp;
 String? createdAt;
 String? paySuccess;
 String? paymentMode;
 String? paymentStatus;
 String? paymentCurrency;
 String? paymentReferenceId;
 String? paymentOrderId;
 String? paymentReceipt;
 String? paymentId;
 String? invoiceId;
 String? paymentGateway;
 double? codPaid;
 double? amountPaid;
 double? amountDue;
 String? paymentMsg;
 String? paymentTime;
 bool? paid;
 String? userFirstName;
 String? userLastName;
 String? userPhone;
 String? userEmail;
 String? invoiceLink;
 String? returnValidTill;
//   user {
//   id;
//   firstName
// }
OrderTrackAddress? address;
List<OrderTrackHistory>? orderHistory;

OrderTrackResponse({
   this.id,this.type,this.address,this.amountDue,this.amountPaid,
  this.brandImg,this.brandName,this.codPaid,this.color,this.courierName,
  this.createdAt,this.days,this.img,this.invoiceId,this.invoiceLink,this.itemOrderNo,
  this.name,this.orderId,this.orderNo,this.otp,this.paid,this.paymentCurrency,this.paymentGateway,
  this.paymentId,this.paymentMode,this.paymentMsg,this.paymentOrderId,this.paymentReceipt,this.paymentReferenceId,
  this.paymentStatus,this.paymentTime,this.paySuccess,this.pid,this.posInvoiceNo,this.price,this.qty,
  this.returnCourierName,this.returnTrackingId,this.returnValidTill,this.shippingCharge,this.size,
  this.slug,this.status,this.tax,this.tracking,this.trackingId,this.userEmail,this.userFirstName,this.userLastName,this.userPhone,this.orderHistory
});

factory OrderTrackResponse.fromJson(Map<String,dynamic> json)=>OrderTrackResponse(
      id: json["id"],
  type: json["id"],
  orderHistory:List<OrderTrackHistory>.from( json["orderHistory"].map((x)=>OrderTrackHistory.fromJson(x))),
  address: OrderTrackAddress.fromJson(json["address"]),
  amountDue: double.parse(json["amountDue"].toString()),
  amountPaid: double.parse(json["amountPaid"].toString()),
  brandImg: json["brandImg"],
  brandName: json["brandName"],
  codPaid: double.parse(json["codPaid"].toString()),
  color: json["color"],
  courierName: json["courierName"],
  createdAt: json["createdAt"],
  days: json["days"],
  img: json["img"],
  invoiceId: json["invoiceId"],
  invoiceLink: json["invoiceLink"],
  itemOrderNo: json["itemOrderNo"],
  name: json["name"],
  orderId: json["orderId"],
  orderNo: json["orderNo"],
  otp: json["otp"],
  paid: json["paid"],
  paymentCurrency: json["paymentCurrency"],
  paymentGateway: json["paymentGateway"],
  paymentId: json["paymentId"],
  paymentMode: json["paymentMode"],
  paymentMsg: json["paymentMsg"],
  paymentOrderId: json["paymentOrderId"],
  paymentReceipt: json["paymentReceipt"],
  paymentReferenceId: json["paymentReferenceId"],
  paymentStatus: json["paymentStatus"],
  paymentTime: json["paymentTime"],
  paySuccess: json["paySuccess"].toString(),
  pid: json["pid"],
  posInvoiceNo: json["posInvoiceNo"],
  price: double.parse(json["price"].toString()),
  qty: json["qty"],
  returnCourierName: json["returnCourierName"],
  returnTrackingId: json["returnTrackingId"],
  returnValidTill: json["returnValidTill"],
  shippingCharge: double.parse(json["shippingCharge"].toString()),
  size: json["size"],
  slug: json["slug"],
  status: json["status"],
  tax: json["tax"],
  tracking: json["tracking"],
  trackingId: json["trackingId"],
  userEmail: json["userEmail"],
  userFirstName: json["userFirstName"],
  userLastName: json["userLastName"],
  userPhone: json["phone"]
      );


}


class OrderTrackAddress{
 String? phone;
 String? email;
 String?  firstName;
 String? lastName;
 String? town;
 String? city;
 String? state;
 int? zip;
 String? address;
 String? lat;
 String? lng;

 OrderTrackAddress(
     {
      this.phone,
      this.address,
      this.city,
      this.email,
      this.firstName,
      this.lastName,
      this.state,
      this.town,
      this.zip,
   });

 factory OrderTrackAddress.fromJson(Map<String, dynamic> json) => OrderTrackAddress(

     email: json["email"],
     phone: json["phone"],
     address: json["address"],
     city: json["city"],
     firstName: json["firstName"],
     lastName: json["lastName"],
     state: json["state"],
     town: json["town"],
     zip: json["zip"],
    );
}


class OrderTrackHistory {
 String? id;
 String? status;
 String? title;
 String? body;
 String? icon;
 bool? public;
 int? index;
 String? time;

 OrderTrackHistory({
   this.status,this.id,this.title,this.body,this.icon,this.index,this.public,this.time
});

 factory OrderTrackHistory.fromJson(Map<String, dynamic> json) =>OrderTrackHistory(
   id: json["id"],
   status: json["status"],
   title: json["title"],
   body: json["body"],
   icon: json["icon"],
   index: json["index"],
   public: json["public"],
   time: json["time"]
 );

}