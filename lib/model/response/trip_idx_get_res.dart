// To parse this JSON data, do
//
//     final tripIdGetResponse = tripIdGetResponseFromJson(jsonString);

import 'dart:convert';

TripIdGetResponse tripIdGetResponseFromJson(String str) =>
    TripIdGetResponse.fromJson(json.decode(str));

String tripIdGetResponseToJson(TripIdGetResponse data) =>
    json.encode(data.toJson());

class TripIdGetResponse {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripIdGetResponse({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripIdGetResponse.fromJson(Map<String, dynamic> json) =>
      TripIdGetResponse(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "name": name,
    "country": country,
    "coverimage": coverimage,
    "detail": detail,
    "price": price,
    "duration": duration,
    "destination_zone": destinationZone,
  };
}
