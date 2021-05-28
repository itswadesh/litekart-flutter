class CategoryData {
  String id;
  String name;
  String img;
  String namePath;
  String slug;
  int level;
  String metaTitle;
  String metaDescription;
  String metaKeywords;
  int position;
  bool megaMenu;
  bool active;
  bool featured;
  bool shopbycategory;
  String createdAt;
  String updatedAt;

  CategoryData(
      {this.id,
      this.name,
      this.img,
      this.active,
      this.createdAt,
      this.featured,
      this.level,
      this.megaMenu,
      this.metaDescription,
      this.metaKeywords,
      this.metaTitle,
      this.namePath,
      this.position,
      this.shopbycategory,
      this.slug,
      this.updatedAt});

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
      name: json["name"],
      img: json["img"],
      active: json["active"],
      createdAt: json["createdAt"],
      featured: json["featured"],
      level: json["level"],
      megaMenu: json["megaMenu"],
      metaDescription: json["metaDescription"],
      metaKeywords: json["metaKeywords"],
      metaTitle: json["metaTitle"],
      namePath: json["namePath"],
      position: json["position"],
      shopbycategory: json["shopbycategory"],
      slug: json["slug"],
      updatedAt: json["updatedAt"]);
}
