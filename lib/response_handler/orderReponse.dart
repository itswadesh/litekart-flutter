

class OrderResponse {
  int count;
  int pageSize;
  int page;
  List<OrderData> data;

  OrderResponse({this.data, this.pageSize, this.page, this.count});

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      OrderResponse(
          count: json["count"],
          pageSize: json["pageSize"],
          page: json["page"],
          data: List<OrderData>.from(
              json["data"].map((x) => OrderData.fromJson(x))));
}

class OrderData {
 String id;
 String orderNo;
 String otp;
 String createdAt;
 String updatedAt;
  String paymentMode;
 String paymentStatus;
 String paymentCurrency;
 String paymentReferenceId;
 String paymentOrderId;
 String paymentReceipt;
 String invoiceId;
 String paymentGateway;
 double codPaid;
 double amountPaid;
 double amountDue;
 String paymentMsg;
 String paymentTime;
 bool paid;
 OrderAmount amount;
 String userFirstName;
 String userLastName;
 String userPhone;
 OrderAddress address;
 List<OrderItems> items;

 OrderData({
   this.id,this.items,this.paymentMode,this.updatedAt,
   this.createdAt,this.address,this.orderNo,this.amount,this.otp,this.amountDue,this.amountPaid,
   this.codPaid,this.invoiceId,this.paid,this.paymentCurrency,this.paymentGateway,
   this.paymentMsg,this.paymentOrderId,this.paymentReceipt,this.paymentReferenceId,this.paymentStatus,
   this.paymentTime,this.userFirstName,this.userLastName,this.userPhone
});

 factory OrderData.fromJson(Map<String, dynamic> json)=>
     OrderData(
       id: json["id"],
       items: (json["orderItems"]!=null ||json["orderItems"].length!=0)? List<OrderItems>.from(
           json["orderItems"].map((x) => OrderItems.fromJson(x))):[OrderItems()],
       paymentMode: json["paymentMode"],
       updatedAt: json["updatedAt"],
       createdAt: json["createdAt"],
       address: json["address"]!=null?OrderAddress.fromJson(json["address"]):OrderAddress(),
       orderNo: json["orderNo"],
       amount: json["amount"]!=null?OrderAmount.fromJson(json["amount"]):OrderAmount(),
       otp: json["otp"],
       amountDue: double.parse(json["amountDue"].toString()),
       amountPaid: double.parse(json["amountPaid"].toString()),
       codPaid: double.parse(json["codPaid"].toString()),
       invoiceId: json["invoiceId"],
       paid: json["paid"],
       paymentCurrency: json["paymentCurrency"],
       paymentGateway: json["paymentGateway"],
       paymentMsg: json["paymentMsg"],
       paymentOrderId: json["paymentOrderId"],
       paymentReceipt: json["paymentReceipt"],
       paymentReferenceId: json["paymentReferenceId"],
       paymentStatus: json["paymentStatus"],
       paymentTime: json["paymentTime"],
       userFirstName: json["userFirstName"],
       userLastName: json["userLastName"],
       userPhone: json["userPhone"]
     );

}

class OrderItems {
  String id;
  String pid;
  String posInvoiceNo;
  String itemOrderNo;
  String name;
  String barcode;
  String img;
  String slug;
  double price;
  int qty;
  double shippingCharge;
  double tax;
  String time;
  String options;
  String brandName;
  String brandImg;
  String status;
  List<OrderStatus> orderStatus;
  OrderVendor vendor;

  OrderItems({
    this.id,
    this.vendor,this.orderStatus,this.status,this.slug,this.name,this.img,
    this.price,this.pid,this.qty,this.brandName,this.barcode,this.tax,this.options,
    this.time,this.brandImg,this.itemOrderNo,this.posInvoiceNo,this.shippingCharge
});

  factory OrderItems.fromJson(Map<String, dynamic> json)=>
      OrderItems(
        id: json["id"],
        vendor: json["vendor"]!=null? OrderVendor.fromJson(json["vendor"]):OrderVendor(),
        orderStatus: (json["orderStatus"]!=null||json["orderStatus"].length!=0)? List<OrderStatus>.from(
            json["orderStatus"].map((x) => OrderStatus.fromJson(x))):[OrderStatus()],
        status: json["status"],
        slug: json["slug"],
        name: json["name"],
        img: json["imgCdn"],
        price: double.parse(json["price"].toString()),
        pid: json["pid"],
        qty: json["qty"],
        brandName: json["brandName"],
        barcode: json["barcode"],
        tax: double.parse(json["tax"].toString()),
        options: json["options"],
        time: json["time"],
        brandImg: json["brandImg"],
        itemOrderNo: json["itemOrderNo"],
        posInvoiceNo: json["posInvoiceNo"],
        shippingCharge: double.parse(json["shippingCharge"].toString())
      );

}

class OrderVendor {
  String firstName;
  String lastName;
  String phone;
 // String address;
  String store;

  OrderVendor({
    //this.address,
    this.phone,this.firstName,this.lastName,this.store
});

  factory OrderVendor.fromJson(Map<String, dynamic>json)=>
      OrderVendor(
        firstName: json["firstName"],
        lastName: json["lastName"],
        phone: json["phone"],
        //address: json["address"][0]["address"],
        store: json["store"]
      );
}

class OrderStatus {
 String id;
 String event;
 String trackingId;
 String courierName;

 OrderStatus({
   this.id,this.courierName,this.event,this.trackingId
});

 factory OrderStatus.fromJson(Map<String, dynamic>json)=>
     OrderStatus(
       id: json["id"],
       event: json["event"],
       trackingId: json["tracking_id"],
       courierName: json["courier_name"]
     );

}

class OrderAddress {

  String firstName;
  String lastName;
  String address;
  String town;
  String city;
  String lat;
  String lng;
  String state;
  int zip;
  String email;
  String phone;


  OrderAddress(
      {
        this.phone,
        this.email,
        this.address,
        this.city,
        this.firstName,
        this.lastName,
        this.state,
        this.town,
        this.zip,
        this.lat,
        this.lng
        });

  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
      city: json["city"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      state: json["state"],
      town: json["town"],
      zip: json["zip"],
      lat: json["lat"],
      lng: json["lng"]);
}

class OrderAmount {
  int qty;
  double subtotal;
  double tax;
  double discount;
  double total;
  double shipping;

  OrderAmount({this.tax,this.qty,this.discount,this.subtotal,this.shipping,this.total});

  factory OrderAmount.fromJson(Map<String, dynamic>json)=>
      OrderAmount(
        qty: json['qty'],
        subtotal: double.parse(json["subtotal"].toString()),
        tax: double.parse(json["tax"].toString()),
        discount: double.parse(json["discount"].toString()),
        total: double.parse(json["total"].toString()),
        shipping: double.parse(json["shipping"].toString())
      );
}