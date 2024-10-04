import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madaride/model/ride.dart';
import 'package:madaride/utils/function.dart';
import '../../service/api_service.dart';

class ShowRidePage extends StatefulWidget {
  final String slug;

  const ShowRidePage({super.key, required this.slug});

  @override
  State<ShowRidePage> createState() => _ShowRidePageState();
}

class _ShowRidePageState extends State<ShowRidePage> {
  final ApiService _apiService = ApiService();
  late Future<Ride> _futureTrip;

  @override
  void initState() {
    super.initState();
    _futureTrip = _apiService.getRideBySlug(widget.slug);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du trajet'),
      ),
      body: FutureBuilder<Ride>(
        future: _futureTrip,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final trip = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.blue), // Icône départ
                      const SizedBox(width: 8),
                      Text(getFirstElement(trip.departureLocation.label), style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.green), // Icône arrivée
                      const SizedBox(width: 8),
                      Text(getFirstElement(trip.arrivalLocation.label), style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.yellow), // Icône date
                      const SizedBox(width: 8),
                      Text(formatDate(trip.departureDateTime.toString()), style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.event_seat, color: Colors.orange), // Icône sièges
                      const SizedBox(width: 8),
                      Text('${trip.availableSeats} places disponibles', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.green), // Icône prix
                      const SizedBox(width: 8),
                      Text('${formatPrice(trip.price)} MGA une place', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text("Mots du conducteur", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text(trip.description),
                  const SizedBox(height: 8),
                  const Text("Conducteur", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  // Détails du conducteur (driver)
                  GestureDetector(
                    onTap: () {
                      // Logique lors du clic sur la ligne du conducteur
                      Get.snackbar('Conducteur', 'Détails du conducteur');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage("http://172.20.10.9:8000/storage/${trip.driver.bustFile}"),
                              radius: 20, // Image du conducteur
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(trip.driver.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                const Row(
                                  children: [
                                    Text('4.5', style: TextStyle(fontSize: 14)),
                                    SizedBox(width: 5),
                                    Icon(Icons.star, color: Colors.yellow, size: 18),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey), // Icône flèche
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 8),
                  const Text("Véhicule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  // Détails du véhicule (car)
                  GestureDetector(
                    onTap: () {
                      // Logique lors du clic sur la ligne du véhicule
                      Get.snackbar('Véhicule', 'Détails du véhicule');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.directions_car, color: Colors.orange), // Icône véhicule
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${trip.car.make} ${trip.car.model}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                Text(trip.car.license_plate, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey), // Icône flèche
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 8),
                  const Text("Covoitureurs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  const Text("Soyez le premier à réserver!"),
                  const SizedBox(height: 16),

                  // Bouton de réservation
                  ElevatedButton(
                    onPressed: () {
                      // Logique pour réserver le trajet
                      Get.snackbar('Réservation', 'Fonctionnalité à implémenter');
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: const Color(0xFFFFFFFF)),
                    child: const Text('Réserver'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Aucune donnée disponible'));
          }
        },
      ),
    );
  }
}
