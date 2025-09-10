// To parse this JSON data, do
//
//     final userIdGetResponse = userIdGetResponseFromJson(jsonString);

import 'dart:convert';

UserIdGetResponse userIdGetResponseFromJson(String str) =>
    UserIdGetResponse.fromJson(json.decode(str));

String userIdGetResponseToJson(UserIdGetResponse data) =>
    json.encode(data.toJson());

class UserIdGetResponse {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  UserIdGetResponse({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory UserIdGetResponse.fromJson(Map<String, dynamic> json) =>
      UserIdGetResponse(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
  };
}
