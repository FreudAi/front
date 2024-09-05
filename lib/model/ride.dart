import 'dart:convert';

class Location {
  final String label;
  final double lat;
  final double lon;

  Location({required this.label, required this.lat, required this.lon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      label: json['label'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class Driver {
  final String name;
  final String bustFile;
  final String email;
  final String address;
  final String phoneNumber;

  Driver({
    required this.name,
    required this.bustFile,
    required this.email,
    required this.address,
    required this.phoneNumber,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      name: json['name'],
      bustFile: json['bust_file'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phone_number'],
    );
  }
}

class Ride {
  final int id;
  final Location departureLocation;
  final Location arrivalLocation;
  final DateTime departureDateTime;
  final int availableSeats;
  final Driver driver;
  final double price;
  final String slug;
  final bool bookingAuto;

  Ride({
    required this.id,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.departureDateTime,
    required this.availableSeats,
    required this.driver,
    required this.price,
    required this.slug,
    required this.bookingAuto,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      departureLocation: Location.fromJson(jsonDecode(json['departure_location'])),
      arrivalLocation: Location.fromJson(jsonDecode(json['arrival_location'])),
      departureDateTime: DateTime.parse(json['departure_datetime']),
      availableSeats: json['available_seats'],
      driver: Driver.fromJson(json['driver']),
      price: double.parse(json['price']),
      slug: json['slug'],
      bookingAuto: json['booking_auto'],
    );
  }
}