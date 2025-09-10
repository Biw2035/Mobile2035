import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/response/trip_get_res.dart';
import 'package:flutter_application_1/page/profile.dart';
import 'package:flutter_application_1/page/trip.dart';
import 'package:http/http.dart' as http;

class ShowTripPage extends StatefulWidget {
  final int userId;
  const ShowTripPage({super.key, required this.userId});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  List<TripGetResponse> tripGetResponses = [];
  List<TripGetResponse> setLoadData = [];
  String url = '';
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการทริป"),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.userId),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              PopupMenuItem<String>(value: 'logout', child: Text('ออกจากระบบ')),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // filter buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ปลายทาง',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilledButton(onPressed: getAll, child: const Text('ทั้งหมด')),
                FilledButton(onPressed: getAsia, child: const Text('เอเชีย')),
                FilledButton(onPressed: getEurope, child: const Text('ยุโรป')),
                FilledButton(onPressed: getAsean, child: const Text('อาเซียน')),
                FilledButton(
                  onPressed: getSouthEastAsia,
                  child: const Text('เอเชียตะวันออกเฉียงใต้'),
                ),
                FilledButton(
                  onPressed: getThailand,
                  child: const Text('ประเทศไทย'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // FutureBuilder load data
          FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: ListView(
                  children: setLoadData
                      .map(
                        (trip) => Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    trip.coverimage,
                                    height: 150,
                                    width: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 150,
                                        width: 180,
                                        color: Colors.grey,
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${trip.name}\nราคา ${trip.price} บาท ID = ${trip.idx}\nระยะเวลา ${trip.duration}\nโซนปลายทาง ${trip.destinationZone}',
                                      ),
                                      const SizedBox(height: 8),
                                      FilledButton(
                                        onPressed: () => gotoTrip(trip.idx),
                                        child: const Text(
                                          'รายละเอียดเพิ่มเติม',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void gotoTrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }

  void getAsia() {
    setState(() {
      setLoadData = tripGetResponses
          .where((trip) => trip.destinationZone == 'เอเชีย')
          .toList();
    });
  }

  void getEurope() {
    setState(() {
      setLoadData = tripGetResponses
          .where((trip) => trip.destinationZone == 'ยุโรป')
          .toList();
    });
  }

  void getAsean() {
    setState(() {
      setLoadData = tripGetResponses
          .where((trip) => trip.destinationZone == 'อาเซียน')
          .toList();
    });
  }

  void getSouthEastAsia() {
    setState(() {
      setLoadData = tripGetResponses
          .where((trip) => trip.destinationZone == 'เอเชียตะวันออกเฉียงใต้')
          .toList();
    });
  }

  void getThailand() {
    setState(() {
      setLoadData = tripGetResponses
          .where((trip) => trip.destinationZone == 'ประเทศไทย')
          .toList();
    });
  }

  void getAll() {
    setState(() {
      setLoadData = tripGetResponses;
    });
  }

  Future<void> getTrips() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    tripGetResponses = tripGetResponseFromJson(res.body);
    setLoadData = tripGetResponses;
    log(tripGetResponses.length.toString());
  }
}
