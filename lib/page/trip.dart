import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TripIdxGetResponse {
  final String name;
  final String country;
  final String destinationZone;
  final int duration;
  final int price;
  final String coverimage;
  final String detail;

  TripIdxGetResponse({
    required this.name,
    required this.country,
    required this.destinationZone,
    required this.duration,
    required this.price,
    required this.coverimage,
    required this.detail,
  });

  factory TripIdxGetResponse.fromJson(Map<String, dynamic> json) {
    return TripIdxGetResponse(
      name: json['name'],
      country: json['country'],
      destinationZone: json['destination_zone'],
      duration: json['duration'],
      price: json['price'],
      coverimage: json['coverimage'],
      detail: json['detail'],
    );
  }
}

class TripPage extends StatefulWidget {
  final int idx;
  const TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late Future<TripIdxGetResponse> futureTrip;

  @override
  void initState() {
    super.initState();
    futureTrip = fetchTrip(widget.idx);
  }

  Future<TripIdxGetResponse> fetchTrip(int id) async {
    final res = await http.get(Uri.parse("http://192.168.1.136:3000/trip/$id"));
    if (res.statusCode == 200) {
      return TripIdxGetResponse.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("โหลดข้อมูลไม่สำเร็จ (${res.statusCode})");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายละเอียดทริป")),
      body: FutureBuilder<TripIdxGetResponse>(
        future: futureTrip,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("ผิดพลาด: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("ไม่พบข้อมูล"));
          }

          final trip = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    trip.coverimage,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  trip.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text("ประเทศ: ${trip.country}"),
                Text("โซน: ${trip.destinationZone}"),
                Text("ระยะเวลา: ${trip.duration} วัน"),
                Text("ราคา: ${trip.price} บาท"),
                const SizedBox(height: 16),
                Text(trip.detail, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                Center(
                  child: FilledButton(
                    onPressed: () {
                      // ทำการจองทริป
                    },
                    child: const Text("-> จองเลย"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
