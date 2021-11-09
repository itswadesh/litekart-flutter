
class ScheduleListResponse {
  int? count;
  int? page;
  int? pageSize;
  List<ScheduleData>? data;

  ScheduleListResponse({
    this.data,this.pageSize,this.page,this.count
});

  factory ScheduleListResponse.fromJson(Map<String, dynamic> json)=>
      ScheduleListResponse(
        count: json["count"],
        pageSize: json["count"],
        page: json["page"],
        data: List<ScheduleData>.from(json["data"].map((x)=>ScheduleData.fromJson(x)))
      );

}

class ScheduleData {
  String? id;
  int? scheduleDateTime;
  String? title;
  String? img;
  String? imgCdn;
  ScheduleDataProduct? product;
 // List<ScheduleDataProduct>? products;
  ScheduleDataUser? user;
 // List<ScheduleDataUser>? users;

  ScheduleData({
    this.id,this.title,this.user,this.product,this.img,this.scheduleDateTime,this.imgCdn
});

  factory ScheduleData.fromJson(Map<String, dynamic> json)=>
      ScheduleData(
        id: json["id"],
        scheduleDateTime: json["scheduleDateTime"],
        title: json["title"],
        img: json["img"],
        imgCdn: json["imgCdn"],
      //  products: List<ScheduleDataProduct>.from(json["products"].map((x)=>ScheduleDataProduct.fromJson(x))),
        product: ScheduleDataProduct.fromJson(json["product"]),
       // users: List<ScheduleDataUser>.from(json["users"].map((x)=>ScheduleDataUser.fromJson(x))),
        user: ScheduleDataUser.fromJson(json["user"])
      );
}

class ScheduleDataProduct {
  String? id;
  String? name;
  String? img;
  String? imgCdn;
  String? slug;
  double? price;
  double? mrp;

  ScheduleDataProduct({
    this.id,this.imgCdn,this.img,this.name,this.slug,this.price,this.mrp
});

 factory ScheduleDataProduct.fromJson(Map<String, dynamic> json)=>
     ScheduleDataProduct(
       imgCdn: json["imgCdn"],
       id: json["id"],
       img: json["img"],
       name: json["name"],
       slug: json["slug"],
       price: double.parse(json["price"].toString()),
       mrp: double.parse(json["mrp"].toString())
     );
}

class ScheduleDataUser {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  ScheduleDataUser({
    this.id, this.firstName,this.phone,this.lastName,this.email
});

  factory ScheduleDataUser.fromJson(Map<String, dynamic> json)=>
      ScheduleDataUser(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"]
      );

}