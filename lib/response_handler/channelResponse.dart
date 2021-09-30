
class ChannelResponse {
 int count;
 int page;
 int pageSize;
 List<ChannelData> data ;

 ChannelResponse({
   this.count,this.page,this.pageSize,this.data
});

 factory ChannelResponse.fromJson(Map<String,dynamic> json)=>
     ChannelResponse(
       count: json["count"],
       page: json["page"],
       pageSize: json["pageSize"],
       data: (json["data"]!=null && json["data"].length!=0)? List<ChannelData>.from(json["data"].map((x)=>ChannelData.fromJson(x))):[ChannelData()]
     );
}

class ChannelData {
  String id;
  int scheduleDateTime;
  String title;
  String img;
  String requestId;
  String cid;
  String ctime;
  String pushUrl;
  String httpPullUrl;
  String hlsPullUrl;
  String rtmpPullUrl;
  String name;
  String code;
  String msg;
  ChannelProduct product;
  List<ChannelProduct> products;
  ChannelUser user;
  List<ChannelUser> users;

  ChannelData({
    this.img,this.id,
    this.user,
    this.scheduleDateTime,this.title,this.name,
    this.product,
    this.cid,this.code,this.ctime,this.hlsPullUrl,this.httpPullUrl,this.msg,
    this.products,
    this.pushUrl,this.requestId,this.rtmpPullUrl,
    this.users
});

  factory ChannelData.fromJson(Map<String, dynamic> json)=>
      ChannelData(
        img: json["img"],
        id: json["id"],
        scheduleDateTime: json["scheduleDateTime"],
        title: json["title"],
        requestId: json["requestId"],
        cid: json["cid"],
        code: json["code"],
        ctime: json["ctime"],
        pushUrl: json["pushUrl"],
        httpPullUrl: json["httpPullUrl"],
        rtmpPullUrl: json["rtmpPullUrl"],
        name: json["name"],
        msg: json["msg"],
        product: json["product"]!=null? ChannelProduct.fromJson(json["product"]):ChannelProduct(),
        products: (json["products"]!=null && json["products"].length!=0)? List<ChannelProduct>.from(json["products"].map((x)=>ChannelProduct.fromJson(x))):[ChannelProduct()],
        user: json["user"]!=null? ChannelUser.fromJson(json["user"]):ChannelUser(),
        users: (json["users"]!=null && json["users"].length!=0)? List<ChannelUser>.from(json["users"].map((x)=>ChannelUser.fromJson(x))):[ChannelUser()]
      );

}


class ChannelProduct {
  String id;
  String name;
  String img;
  String slug;
  double price;
  double mrp;

  ChannelProduct({
    this.name,this.id,this.img,this.slug,this.mrp,this.price
});

  factory ChannelProduct.fromJson(Map<String, dynamic> json)=>
      ChannelProduct(
        id: json["id"],
        name: json["name"],
        img: json["img"],
        slug: json["slug"],
        price: double.parse(json["price"].toString()),
        mrp: double.parse(json["mrp"].toString())
      );
}

class ChannelUser {
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;

  ChannelUser({
   this.id,this.phone,this.email,this.firstName,this.lastName
});

  factory ChannelUser.fromJson(Map<String, dynamic> json)=>
      ChannelUser(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"]
      );

}