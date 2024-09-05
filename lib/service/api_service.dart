import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:madaride/model/ride.dart';

class ApiService {
  final String baseUrl = 'http://172.20.10.9:8000/api';

  Future<List<Ride>> searchTrips(String departure, String arrival, DateTime date, int places) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search-ride'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'depart': departure,
        'arrive': arrival,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'places': places,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Ride.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load trips: ${response.statusCode}');
    }
  }
}