class BrandResponse {
  int count;
  int page;
  int pageSize;
  List<BrandData> data;

  BrandResponse({this.count, this.page, this.data, this.pageSize});

  factory BrandResponse.fromJson(Map<String, dynamic> json) => BrandResponse(
        count: json["count"],
        page: json["page"],
        pageSize: json["pageSize"],
        data: List<BrandData>.from(
            json["data"].map((x) => BrandData.fromJson(x))),
      );
}

class BrandData {
  String id;
  String brandId;
  String slug;
  String img;
  int position;
  String name;
  String meta;
  String metaTitle;
  String metaDescription;
  String metaKeywords;
  bool featured;
  bool active;
  String createdAt;
  String updatedAt;
  String facebookUrl;
  String instaUrl;
  String twitterUrl;
  String linkedinUrl;
  String youtubeUrl;

  BrandData(
      {this.id,
      this.brandId,
      this.active,
      this.name,
      this.metaDescription,
      this.featured,
      this.position,
      this.slug,
      this.metaTitle,
      this.metaKeywords,
      this.meta,
      this.img,
      this.createdAt,
      this.updatedAt,
      this.facebookUrl,
      this.instaUrl,
      this.twitterUrl,
      this.linkedinUrl,
      this.youtubeUrl});

  factory BrandData.fromJson(Map<String, dynamic> json) =>
      BrandData(
          id: json["id"] ?? null,
          brandId: json["brandId"] ?? null,
          name: json["name"] ?? null,
          meta: json["meta"] ?? null,
          metaDescription: json["metaDescription"] ?? null,
          metaKeywords: json["metaKeywords"] ?? null,
          metaTitle: json["metaTitle"] ?? null,
          featured: json["featured"] ?? null,
          slug: json["slug"] ?? null,
          position: json["position"] ?? null,
          img: json["img"] ?? null,
          facebookUrl: json["facebookUrl"] ?? null,
          instaUrl: json["instaUrl"] ?? null,
          twitterUrl: json["twitterUrl"] ?? null,
          linkedinUrl: json["linkedinUrl"] ?? null,
          youtubeUrl: json["youtubeUrl"] ?? null,
          active: json["active"] ?? null,
          createdAt: json["createdAt"] ?? null,
          updatedAt: json["updatedAt"]) ??
      null;
}
