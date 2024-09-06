import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madaride/model/ride.dart';
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('De: ${trip.departureLocation.label}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('À: ${trip.arrivalLocation.label}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text('Date de départ: ${DateFormat('dd/MM/yyyy HH:mm').format(trip.departureDateTime)}'),
                  Text('Places disponibles: ${trip.availableSeats}'),
                  Text('Prix: ${trip.price} €'),
                  const SizedBox(height: 16),
                  const Text('Conducteur:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Nom: ${trip.driver.name}'),
                  Text('Email: ${trip.driver.email}'),
                  Text('Téléphone: ${trip.driver.phoneNumber}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Ajouter ici la logique pour réserver le trajet
                      Get.snackbar('Réservation', 'Fonctionnalité à implémenter');
                    },
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