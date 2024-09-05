import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madaride/model/ride.dart';

class SearchResultPage extends StatelessWidget {
  final List<Ride> trips;

  const SearchResultPage({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Résultats de recherche'),
          backgroundColor: const Color(0xFF1D4ED8),
          foregroundColor: const Color(0xFFFFFFFF)),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return rideCard(trip);
        },
      ),
    );
  }

  Widget rideCard(Ride ride) {
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 20),
                    const SizedBox(width: 5),
                    Text("${ride.availableSeats} places",
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                Text("${ride.price} MGA",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
            const Divider(thickness: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.place, size: 20),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ride.departureLocation.label.split(",")[0],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        //Text(ride.departureLocation.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.flag, size: 20),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ride.arrivalLocation.label.split(",")[0],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        //Text(ride.arrivalLocation.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.date_range, size: 20),
                    const SizedBox(width: 5),
                    Text("${ride.departureDateTime}",
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_circle, size: 20),
                    const SizedBox(width: 5),
                    Text(ride.driver.name,
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const Row(
                  children: [
                    Text("4,5", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 5),
                    Icon(Icons.star, size: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
