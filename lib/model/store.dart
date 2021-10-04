class StoreData {

  String id;
  StoreData({
    this.id
  });
  factory StoreData.fromJson(Map<String, dynamic> json)=>StoreData(
      id:json["id"]
  );
}