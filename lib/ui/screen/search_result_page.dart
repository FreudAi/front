import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madaride/model/ride.dart';
import 'package:madaride/ui/screen/show_ride_screen.dart';
import '../../service/api_service.dart';

class SearchResultPage extends StatefulWidget {
  final String? depart;
  final String? arrive;
  final String? date;
  final String? places;

  SearchResultPage({super.key})
      : depart = Get.parameters['depart'],
        arrive = Get.parameters['arrive'],
        date = Get.parameters['date'],
        places = Get.parameters['places'],
        assert(Get.parameters['depart'] != null,
        'Le paramètre "depart" ne peut pas être null'),
        assert(Get.parameters['arrive'] != null,
        'Le paramètre "arrive" ne peut pas être null'),
        assert(Get.parameters['date'] != null,
        'Le paramètre "date" ne peut pas être null'),
        assert(Get.parameters['places'] != null,
        'Le paramètre "places" ne peut pas être null');

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Ride>> _futureRides;

  @override
  void initState() {
    super.initState();
    _fetchRides();
  }

  void _fetchRides() {
    try {
      final parsedDate = DateTime.parse(widget.date!);
      final parsedPlaces = int.parse(widget.places!);

      _futureRides = _apiService.searchTrips(
        widget.depart!,
        widget.arrive!,
        parsedDate,
        parsedPlaces,
      );
    } catch (e) {
      // En cas d'erreur de parsing, on retourne une liste vide
      _futureRides = Future.error('Erreur lors du traitement des données');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats de recherche'),
        backgroundColor: const Color(0xFF1D4ED8),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: FutureBuilder<List<Ride>>(
        future: _futureRides,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ride = snapshot.data![index];
                return _RideCard(ride: ride);
              },
            );
          } else {
            return const Center(child: Text('Aucun trajet trouvé!'));
          }
        },
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  final Ride ride;

  const _RideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () {
          Get.to(() => ShowRidePage(slug: ride.slug));
        },
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRideInfoRow(
                    icon: Icons.person,
                    label: "${ride.availableSeats} places",
                  ),
                  _buildRideInfoRow(
                    icon: Icons.monetization_on,
                    label: "${ride.price} MGA",
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const Divider(),
              _buildLocationInfo(
                icon: Icons.place,
                location: ride.departureLocation.label,
              ),
              const SizedBox(height: 10),
              _buildLocationInfo(
                icon: Icons.flag,
                location: ride.arrivalLocation.label,
              ),
              const SizedBox(height: 10),
              _buildRideInfoRow(
                icon: Icons.date_range,
                label: ride.departureDateTime.toString(),
              ),
              const Divider(),
              _buildDriverInfo(ride.driver.name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRideInfoRow({
    required IconData icon,
    required String label,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: fontWeight)),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationInfo({
    required IconData icon,
    required String location,
  }) {
    final locationParts = location.split(",");
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locationParts.first,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDriverInfo(String driverName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.account_circle, size: 20),
            const SizedBox(width: 5),
            Text(driverName, style: const TextStyle(fontSize: 14)),
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
    );
  }
}
