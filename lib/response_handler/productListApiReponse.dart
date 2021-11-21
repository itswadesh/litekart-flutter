class ProductListApiResponse {
  int? count;
  int? took;
  int? page;
  List<ProductListData>? data;

  ProductListApiResponse({this.data, this.page, this.count, this.took});

  factory ProductListApiResponse.fromJson(Map<String, dynamic> json) =>
      ProductListApiResponse(
          count: json["count"],
          took: json["took"],
          page: json["page"],
          // facets: json["facets"],
          data: json["data"] != null
              ? List.from(json["data"].map((x) => ProductListData.fromJson(x)))
              : [ProductListData(images: [], imgCdn: "")]);
}

class ProductListData {
  String? id;
  String? name;
  String? brand;
  List<String> images;
  String imgCdn;
  double? price;
  double? mrp;
  int? stock;

  ProductListData(
      {this.id,
      this.name,
      this.mrp,
      this.price,
     required this.images,
      this.stock,
      this.brand,required this.imgCdn});

  factory ProductListData.fromJson(Map<String, dynamic> json) =>
      ProductListData(
          id: json["_id"] ?? "",
          name: json["_source"] != null ? (json["_source"]["name"] ?? "") : "",
          brand: json["_source"] != null
              ? (json["_source"]["brand"] != null
                  ? json["_source"]["brand"]["name"]
                  : "")
              : "",
          images: json["_source"] != null ? (json["_source"]["imagesCdn"] != null && json["_source"]["imagesCdn"].length!=0
              ? List.from(json["_source"]["imagesCdn"].map((x) => x)):[]):[],
          price: json["_source"] != null
              ? double.parse(json["_source"]["price"].toString()) ?? 0.0
              : 0.0,
          mrp: json["_source"] != null
              ? double.parse(json["_source"]["mrp"].toString()) ?? 0.0
              : 0.0,
          stock: json["_source"] != null ?( json["_source"]["stock"] ?? 0) : 0,
          imgCdn: json["_source"]["imgCdn"]??""
      );

}
