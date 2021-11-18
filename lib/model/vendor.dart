import 'address.dart';

class Vendor {
  String? id;
  String? firstName;
  String? lastName;
  int? phone;
  String? email;
  List<Address>? address;

  Vendor(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.phone});

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        address:
            List<Address>.from(json["address"].map((x) => Address.fromJson(x))),
      );
}
