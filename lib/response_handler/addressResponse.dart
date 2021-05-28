import 'package:anne/model/address.dart';

class AddressResponse {
  int count;
  int page;
  int pageSize;
  List<Address> data;

  AddressResponse({this.count, this.page, this.data, this.pageSize});

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      AddressResponse(
        count: json["count"],
        page: json["page"],
        pageSize: json["pageSize"],
        data: List<Address>.from(json["data"].map((x) => Address.fromJson(x))),
      );
}
