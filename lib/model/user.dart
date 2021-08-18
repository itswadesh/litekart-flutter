class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  String role;
  bool verified;
  bool active;
  String provider;
  String avatar;
  List<UserAddress> address;

  User(
      {this.active,
      this.id,
      this.phone,
      this.address,
      this.email,
      this.lastName,
      this.firstName,
      this.avatar,
      this.gender,
      this.provider,
      this.role,
      this.verified});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      phone: json["phone"],
      gender: json["gender"],
      role: json["role"],
      verified: json["verified"],
      active: json["active"],
      provider: json["provider"],
      avatar: json["avatar"],
      address: List<UserAddress>.from(
          json["address"].map((x) => UserAddress.fromJson(x))));

  Map<String, dynamic> get values => {
        'active': this.active,
        'id': this.id,
        'phone': this.phone,
        'address': this.address,
        'email': this.email,
        'lastName': this.lastName,
        'firstName': this.firstName,
        'avatar': this.avatar,
        'gender': this.gender,
        'provider': this.provider,
        'role': this.role,
        'verified': this.verified
      };
}

class UserAddress {
  String address;
  String town;
  String city;

  String state;
  int zip;

  UserAddress({this.address, this.city, this.state, this.town, this.zip});

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
      address: json["address"],
      city: json["city"],
      state: json["state"],
      town: json["town"],
      zip: json["zip"]);
}
