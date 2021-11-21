class TopMegaMenuResponse {
  List<MegaMenuResponse>? megamenu;

  TopMegaMenuResponse({this.megamenu});

  factory TopMegaMenuResponse.fromJson(Map<String, dynamic> json) =>
      TopMegaMenuResponse(
        megamenu: json["megamenu"].length != 0
            ? List<MegaMenuResponse>.from(
                json["megamenu"].map((x) => MegaMenuResponse.fromJson(x)))
            : [MegaMenuResponse()],
      );
}

class MegaMenuResponse {
  String? id;
  String? name;
  String? slug;
  String? img;
  bool? featured;
  List<MegaMenuChildren1>? children;

  MegaMenuResponse(
      {this.id, this.img, this.slug, this.name, this.children, this.featured});

  factory MegaMenuResponse.fromJson(Map<String, dynamic> json) =>
      MegaMenuResponse(
        id: json["id"],
        name: json["name"],
        img: json["imgCdn"]??null,
        slug: json["slug"],
        featured: json["featured"],
        children: json["children"].length != 0
            ? List<MegaMenuChildren1>.from(
                json["children"].map((x) => MegaMenuChildren1.fromJson(x)))
            : [MegaMenuChildren1()],
      );
}

class MegaMenuChildren1 {
  String? name;
  String? slug;
  String? img;
  bool? featured;
  List<MegaMenuChildren2>? children;

  MegaMenuChildren1(
      {this.img, this.slug, this.name, this.children, this.featured});

  factory MegaMenuChildren1.fromJson(Map<String, dynamic> json) =>
      MegaMenuChildren1(
        name: json["name"],
        img: json["imgCdn"],
        featured: json["featured"],
        children: json["children"].length != 0
            ? List<MegaMenuChildren2>.from(
                json["children"].map((x) => MegaMenuChildren2.fromJson(x)))
            : [MegaMenuChildren2()],
      );
}

class MegaMenuChildren2 {
  String? name;
  String? slug;
  String? img;
  bool? featured;
  MegaMenuChildren2({this.img, this.slug, this.name, this.featured});

  factory MegaMenuChildren2.fromJson(Map<String, dynamic> json) =>
      MegaMenuChildren2(
        name: json["name"],
        img: json["imgCdn"],
        featured: json["featured"],
        slug: json["slug"]
      );
}
