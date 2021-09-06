class ProductListApiResponse {
  int count;
  int took;
  int page;
  List<ProductListData> data;

  ProductListApiResponse({this.data, this.page, this.count, this.took});

  factory ProductListApiResponse.fromJson(Map<String, dynamic> json) =>
      ProductListApiResponse(
          count: json["count"],
          took: json["took"],
          page: json["page"],
          // facets: json["facets"],
          data: json["data"] != null
              ? List.from(json["data"].map((x) => ProductListData.fromJson(x)))
              : [ProductListData()]);
}

class ProductListData {
  String id;
  String name;
  String brand;
  List images;
  double price;
  double mrp;
  int stock;

  ProductListData(
      {this.id,
      this.name,
      this.mrp,
      this.price,
      this.images,
      this.stock,
      this.brand});

  factory ProductListData.fromJson(Map<String, dynamic> json) =>
      ProductListData(
          id: json["_id"] ?? "",
          name: json["_source"] != null ? (json["_source"]["name"] ?? "") : "",
          brand: json["_source"] != null
              ? (json["_source"]["brand"] != null
                  ? json["_source"]["brand"]["name"]
                  : "")
              : "",
          images: json["_source"] != null
              ? ((json["_source"]["images"] != null &&
                      json["_source"]["images"] != [""] &&
                      json["_source"]["images"] != [])
                  ? List.from(json["_source"]["images"].map((x) => x))
                  : [])
              : [],
          price: json["_source"] != null
              ? double.parse(json["_source"]["price"].toString()) ?? 0.0
              : "",
          mrp: json["_source"] != null
              ? double.parse(json["_source"]["mrp"].toString()) ?? 0.0
              : "",
          stock: json["_source"] != null ?( json["_source"]["stock"] ?? 0) : 0);
}
