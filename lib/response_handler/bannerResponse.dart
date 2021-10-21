class SliderResponse {
  int count;
  int page;
  int pageSize;
  List<BannerData> data;

  SliderResponse({this.count, this.page, this.data, this.pageSize});

  factory SliderResponse.fromJson(Map<String, dynamic> json) => SliderResponse(
        count: json["count"],
        page: json["page"],
        pageSize: json["pageSize"],
        data: List<BannerData>.from(
            json["data"].map((x) => BannerData.fromJson(x))),
      );
}

class BannerResponse {
  List<GroupByBannerList> groupByBanner;

  BannerResponse({this.groupByBanner});

  factory BannerResponse.fromJson(Map<String, dynamic> json) => BannerResponse(
        groupByBanner: List<GroupByBannerList>.from(
            json["groupByBanner"].map((x) => GroupByBannerList.fromJson(x))),
      );
}

class GroupByBannerList {
  List<BannerData> data;
  String title;
  GroupByBannerList({this.data,this.title});

  factory GroupByBannerList.fromJson(Map<String, dynamic> json) =>
      GroupByBannerList(
        data: List<BannerData>.from(
            json["data"].map((x) => BannerData.fromJson(x))),
        title: json["_id"]["title"]??""
      );
}

class BannerData {
  String id;
  String img;
  String type;
  String link;
  String heading;
  String pageId;
  String groupId;
  String groupTitle;
  bool active;
  String createdAt;
  String updatedAt;

  BannerData(
      {this.id,
      this.active,
      this.type,
      this.link,
      this.heading,
      this.pageId,
      this.groupId,
      this.groupTitle,
      this.img,
      this.createdAt,
      this.updatedAt});

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
      id: json["id"],
      link: json["link"],
      heading: json["heading"],
      type: json["type"],
      img: json["imgCdn"],
      active: json["active"],
      pageId: json['pageId'],
      groupId: json['groupId'],
      groupTitle: json['groupTitle'],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'active': this.active,
        'type': this.type,
        'link': this.link,
        'heading': this.heading,
        'pageId': this.pageId,
        'groupId': this.groupId,
        'groupTitle': this.groupTitle,
        'img': this.img,
        'createdAt': this.createdAt,
        'updatedAt': this.updatedAt,
      };
}
