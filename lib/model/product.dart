import '../../response_handler/brandResponse.dart';

class ProductData {
  String? id;
  String? sku;
  String? slug;
  String? name;
  String? type;
  double? price;
  double? mrp;
  int? stock;
  String? img;
  List<String>? images;
  String? time;
  bool? active;
  int? popularity;
  int? position;
  bool? trending;
  bool? featured;
  bool? hot;
  bool? sale;
  bool? recommend;
  String? title;
  String? metaDescription;
  String? keywords;
  String? itemId;
  BrandData? brand;
  String? description;
  String? barcode;
  List<LiveStream>? channels;
  // List<SizeGroup> sizeGroup;
  // List<ColorGroup> colorGroup;
  ProductColor? color;
  ProductSize? size;

  //ProductSize size;
  // List<ProductVariant> variants;
  // CategoryData category;
  // Vendor vendor;

  ProductData(
      {this.name,
      this.img,
      this.id,
      this.slug,
      this.position,
      this.metaDescription,
      this.featured,
      this.active,
      this.type,
      // this.category,
      this.time,
      this.images,
      this.title,
      this.hot,
      this.itemId,
      this.keywords,
      this.mrp,
      this.popularity,
      this.price,
      this.recommend,
      this.sale,
      this.sku,
      this.stock,
      this.trending,
      this.brand,
      this.description,
      this.barcode,
      // this.colorGroup,
      // this.sizeGroup,
      this.color,
      this.size,
        this.channels
      // this.variants,
      // this.vendor
      });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
      name: json["name"],
      img: json["imgCdn"],
      id: json["id"],
      slug: json["slug"],
      position: int.parse(json["position"].toString()),
      metaDescription: json["metaDescription"],
      featured: json["featured"],
      active: json["active"],
      type: json["type"] ?? "",
      // category: CategoryData.fromJson(json["category"]),
      time: json["time"] ?? "",
      images: List.from(json["images"].map((x) => x)),
      title: json["title"],
      hot: json["hot"],
      itemId: json["itemId"],
      keywords: json["keywords"],
      mrp: double.parse(json["mrp"].toString()),
      popularity: int.parse(json["popularity"].toString()),
      price: double.parse(json["price"].toString()),
      recommend: json["recommend"],
      sale: json["sale"],
      sku: json["sku"].toString(),
      stock: json["stock"],
      trending: json["trending"],
      brand: json["brand"] != null
          ? BrandData.fromJson(json["brand"])
          : BrandData(),
      description: json["description"],
      barcode: json["barcode"].toString(),
      // sizeGroup: json["sizeGroup"] != null
      //     ? List<SizeGroup>.from(
      //         json["sizeGroup"].map((x) => SizeGroup.fromJson(x)))
      //     : [SizeGroup()],
      // colorGroup: json["colorGroup"] != null
      //     ? List<ColorGroup>.from(
      //         json["colorGroup"].map((x) => ColorGroup.fromJson(x)))
      //     : [ColorGroup()],
      color: json["color"] != null
          ? ProductColor.fromJson(json["color"])
          : ProductColor(),
      size: json["size"] != null
          ? ProductSize.fromJson(json["size"])
          : ProductSize(),
      channels: json["channels"] != null
          ? List<LiveStream>.from(
          json["channels"].map((x) => LiveStream.fromJson(x)))
          : [LiveStream()],
      // variants: List<ProductVariant>.from(json["variants"].map((x)=>ProductVariant.fromJson(x))),
      // vendor: Vendor.fromJson(json["vendor"])
      );
}

class ProductDetailData {
  String? id;
  String? sku;
  String? slug;
  String? name;
  String? type;
  double? price;
  double? mrp;
  int? stock;
  String? img;
  List<String>? images;
  String? time;
  bool? active;
  int? popularity;
  int? position;
  bool? trending;
  bool? featured;
  bool? hot;
  bool? sale;
  bool? recommend;
  String? title;
  String? metaDescription;
  String? keywords;
  String? itemId;
  BrandData? brand;
  String? description;
  String? barcode;
  String? link;
  List<String>? keyFeature;
  List<Specifications>? specifications;
  List<ProductDetails>? productDetails;

  // List<SizeGroup> sizeGroup;
  // List<ColorGroup> colorGroup;
  ProductColor? color;
  ProductSize? size;
  List<Features>? features;
  String? countryOfOrigin;
  String? warranty;

  //ProductSize size;
  // List<ProductVariant> variants;
  // CategoryData category;
  // Vendor vendor;

  ProductDetailData(
      {this.name,
      this.img,
      this.id,
      this.slug,
      this.position,
      this.metaDescription,
      this.featured,
      this.active,
      this.type,
      this.features,
      // this.category,
      this.time,
      this.images,
      this.title,
      this.hot,
      this.itemId,
      this.keywords,
      this.mrp,
      this.popularity,
      this.price,
      this.recommend,
      this.sale,
      this.sku,
      this.stock,
      this.trending,
      this.brand,
      this.description,
      this.barcode,
      // this.colorGroup,
      // this.sizeGroup,
      this.color,
      this.size,
      this.keyFeature,
      this.productDetails,
      this.specifications,
      this.countryOfOrigin,
      this.warranty,
      this.link
      // this.variants,
      // this.vendor
      });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) =>
      ProductDetailData(
          name: json["name"] ?? "",
          img: json["img"],
          id: json["id"],
          slug: json["slug"],
          position: int.parse(json["position"].toString()),
          metaDescription: json["metaDescription"],
          featured: json["featured"],
          active: json["active"],
          type: json["type"].toString(),
          // category: CategoryData.fromJson(json["category"]),
          time: json["time"] ?? "",
          images: json["images"].length != 0
              ? List.from(json["images"].map((x) => x))
              : ["https://next.tablez.com/icon.png"],
          title: json["title"],
          hot: json["hot"],
          itemId: json["itemId"],
          keywords: json["keywords"],
          mrp: double.parse(json["mrp"].toString()),
          popularity: int.parse(json["popularity"].toString()),
          price: double.parse(json["price"].toString()),
          recommend: json["recommend"],
          sale: json["sale"],
          sku: json["sku"].toString(),
          stock: int.parse((json["stock"] ?? 0).toString()),
          trending: json["trending"],
          brand: json["brand"] != null
              ? BrandData.fromJson(json["brand"])
              : BrandData(),
          description: json["description"],
          barcode: json["barcode"].toString(),
          // sizeGroup: json["sizeGroup"] != null
          //     ? List<SizeGroup>.from(
          //     json["sizeGroup"].map((x) => SizeGroup.fromJson(x)))
          //     : [SizeGroup()],
          features: json["features"] != null
              ? List<Features>.from(
                  json["features"].map((x) => Features.fromJson(x)))
              : [Features()],
          specifications: json["specifications"] != null
              ? List<Specifications>.from(
                  json["specifications"].map((x) => Specifications.fromJson(x)))
              : [Specifications()],
          productDetails: json["productDetails"] != null
              ? List<ProductDetails>.from(
                  json["productDetails"].map((x) => ProductDetails.fromJson(x)))
              : [ProductDetails()],
          keyFeature:
              json["keyFeatures"] != null && json["keyFeatures"].length != 0
                  ? List.from(json["keyFeatures"].map((x) => x))
                  : [],
          // colorGroup: json["colorGroup"] != null
          //     ? List<ColorGroup>.from(
          //     json["colorGroup"].map((x) => ColorGroup.fromJson(x)))
          //     : [ColorGroup()],
          color: json["color"] != null
              ? ProductColor.fromJson(json["color"])
              : ProductColor(),
          size: json["size"] != null
              ? ProductSize.fromJson(json["size"])
              : ProductSize(),
          countryOfOrigin: json["countryOfOrigin"],
          warranty: json["warranty"],
          link: json["link"] ?? ""
          // variants: List<ProductVariant>.from(json["variants"].map((x)=>ProductVariant.fromJson(x))),
          // vendor: Vendor.fromJson(json["vendor"])
          );
}

class ProductVariant {
  String? id;
  String? name;
  int? stock;
  double? weight;
  String? sku;
  int? mrp;
  int? price;
  List<String>? images;
  bool? active;

  ProductVariant(
      {this.stock,
      this.sku,
      this.price,
      this.mrp,
      this.images,
      this.active,
      this.id,
      this.name,
      this.weight});

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
      id: json["id"],
      name: json["name"],
      stock: json["stock"],
      weight: json["weight"],
      sku: json["sku"],
      mrp: json["mrp"],
      price: json["price"],
      images: List.from(json["images"].map((x) => x)),
      active: json["active"]);
}

class ColorGroup {
  String? id;
  String? slug;
  ColorData? color;

  ColorGroup({this.slug, this.id, this.color});

  factory ColorGroup.fromJson(Map<String, dynamic> json) => ColorGroup(
      id: json["id"],
      slug: json["slug"],
      color: json["color"] != null
          ? ColorData.fromJson(json["color"])
          : ColorData());
}

class ColorData {
  String? name;
  int? colorCode;

  ColorData({this.name, this.colorCode});

  factory ColorData.fromJson(Map<String, dynamic> json) {
    // print('json["color_code"] :: ${json["color_code"]}');
    int _color;
    try {
      _color = int.parse("0xff" + json["color_code"].toString().substring(1));
    } catch (e) {
      _color = int.parse("0xff808080");
    }

    return ColorData(
      name: json["name"],
      colorCode: _color,
    );
  }
}

class SizeGroup {
  String? id;
  String? slug;
  SizeData? size;

  SizeGroup({this.slug, this.id, this.size});

  factory SizeGroup.fromJson(Map<String, dynamic> json) => SizeGroup(
      id: json["id"],
      slug: json["slug"],
      size:
          json["size"] != null ? SizeData.fromJson(json["size"]) : SizeData());
}

class SizeData {
  String? name;

  SizeData({
    this.name,
  });

  factory SizeData.fromJson(Map<String, dynamic> json) => SizeData(
        name: json["name"],
      );
}

class ProductSize {
  String? name;
  String? id;

  ProductSize({
    this.id,
    this.name,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) =>
      ProductSize(name: json["name"], id: json["id"]);
}

class ProductColor {
  String? name;
  String? id;

  ProductColor({
    this.id,
    this.name,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) =>
      ProductColor(name: json["name"], id: json["id"]);
}

class Features {
  String? id;
  String? name;
  String? value;

  Features({this.name, this.id, this.value});

  factory Features.fromJson(Map<String, dynamic> json) => Features(
      id: json["id"], name: json["name"] ?? "", value: json["value"] ?? "");
}

class Specifications {
  String? id;
  String? name;
  String? value;

  Specifications({this.name, this.id, this.value});

  factory Specifications.fromJson(Map<String, dynamic> json) => Specifications(
      id: json["id"], name: json["name"] ?? "", value: json["value"] ?? "");
}

class ProductDetails {
  String? id;
  String? name;
  String? value;

  ProductDetails({this.name, this.id, this.value});

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
      id: json["id"], name: json["name"] ?? "", value: json["value"] ?? "");
}


class LiveStream {

 String? id;
 String? title;
 String? img;
 String? scheduleDateTime;
 StreamUser? user ;

 LiveStream({
   this.id,this.img,this.title,this.user,this.scheduleDateTime
});

 factory LiveStream.fromJson(Map<String, dynamic> json) => LiveStream(
   id: json["id"],
   title: json["title"],
   img: json["img"],
   scheduleDateTime: json["img"],
   user: json["user"]!=null?StreamUser.fromJson(json["user"]):StreamUser()
 );

}

class StreamUser {

  String? firstName;
  String? lastName;

  StreamUser({
    this.firstName,this.lastName
});

  factory StreamUser.fromJson(Map<String, dynamic> json) => StreamUser(
    firstName: json["firstName"],
    lastName: json["lastName"]
  );

}