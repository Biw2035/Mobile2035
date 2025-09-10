import 'dart:convert';

CustomerRegisPost customerRegisPostFromJson(String str) =>
    CustomerRegisPost.fromJson(json.decode(str));

String customerRegisPostToJson(CustomerRegisPost data) =>
    json.encode(data.toJson());

class CustomerRegisPost {
  String fullname;
  String phone;
  String email;
  String image;
  String password;

  CustomerRegisPost({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
    required this.password,
  });

  factory CustomerRegisPost.fromJson(Map<String, dynamic> json) =>
      CustomerRegisPost(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
    "password": password,
  };
}
