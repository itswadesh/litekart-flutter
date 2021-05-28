class BannerResponse {
  int count;
  int page;
  int pageSize;
  List<BannerData> data;

  BannerResponse({this.count, this.page, this.data, this.pageSize});

  factory BannerResponse.fromJson(Map<String, dynamic> json) => BannerResponse(
        count: json["count"],
        page: json["page"],
        pageSize: json["pageSize"],
        data: List<BannerData>.from(
            json["data"].map((x) => BannerData.fromJson(x))),
      );
}

class BannerData {
  String id;
  String img;
  String type;
  String link;
  String heading;
  bool active;
  String createdAt;
  String updatedAt;

  BannerData(
      {this.id,
      this.active,
      this.type,
      this.link,
      this.heading,
      this.img,
      this.createdAt,
      this.updatedAt});

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
      id: json["id"],
      link: json["link"],
      heading: json["heading"],
      type: json["type"],
      img: json["img"],
      active: json["active"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);
}
