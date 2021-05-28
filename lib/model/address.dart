class Address {
  String id;
  String email;
  String firstName;
  String lastName;
  String address;
  String town;
  String city;
  String country;
  String state;
  int zip;
  String phone;
  bool active;
  String createdAt;
  String updatedAt;

  Address(
      {this.id,
      this.phone,
      this.address,
      this.city,
      this.country,
      this.email,
      this.firstName,
      this.lastName,
      this.state,
      this.town,
      this.zip,
      this.active,
      this.createdAt,
      this.updatedAt});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      id: json["id"],
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
      city: json["city"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      state: json["state"],
      town: json["town"],
      zip: json["zip"],
      country: json["country"],
      active: json["active"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);
}
