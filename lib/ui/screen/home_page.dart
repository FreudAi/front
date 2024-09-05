import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:madaride/ui/kit/drawer.dart';
import 'package:madaride/ui/screen/search_result_page.dart';
import '../../service/api_service.dart';
import 'publish_ride_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _publishRide() {
    Get.to(const PublishRidePage());
  }

  final _formKey = GlobalKey<FormBuilderState>();
  final ApiService _apiService = ApiService();
  double _nombrePlaces = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // Permet au contenu de passer derrière l'AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  // Utilisez le bon contexte pour ouvrir le endDrawer
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildSearchForm(),
            ),
          ],
        ),
      ),
      endDrawer: const RightDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _publishRide,
        tooltip: 'Publish ride',
        backgroundColor: const Color(0xFF1D4ED8),
        foregroundColor: const Color(0xFFFFFFFF),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MadaRide',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Voyagez en toute simplicité à Madagascar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchForm() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'depart',
            decoration: const InputDecoration(
              labelText: 'Lieu de départ',
              prefixIcon: Icon(Icons.location_on),
              //border: OutlineInputBorder(),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          const SizedBox(height: 12),
          FormBuilderTextField(
            name: 'arrivee',
            decoration: const InputDecoration(
              labelText: "Lieu d'arrivée",
              prefixIcon: Icon(Icons.location_on),
              //border: OutlineInputBorder(),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          const SizedBox(height: 12),
          FormBuilderDateTimePicker(
            name: 'date',
            inputType: InputType.date,
            format: DateFormat('yyyy/MM/dd'),
            decoration: const InputDecoration(
              labelText: 'Date du voyage',
              prefixIcon: Icon(Icons.calendar_today),
              //border: OutlineInputBorder(),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          const SizedBox(height: 12),
          _buildSlider(),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _onSearchPressed,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: const Color(0xFFFFFFFF)),
            child: const Text('Rechercher'),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.person, color: Colors.grey),
              const SizedBox(width: 2),
              Text(
                  '${_nombrePlaces.round()} personne${_nombrePlaces != 1 ? 's' : ''}'),
            ]),
            Slider(
              value: _nombrePlaces,
              min: 1,
              max: 5,
              divisions: 4,
              label: _nombrePlaces.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _nombrePlaces = value;
                });
              },
            ),
          ],
        )
      ],
    );
  }

  Future<void> _onSearchPressed() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;
      try {
        final trips = await _apiService.searchTrips(
          formData['depart'],
          formData['arrivee'],
          formData['date'],
          _nombrePlaces.round(),
        );
        Get.to(() => SearchResultPage(trips: trips));
      } catch (e) {
        Get.snackbar('Erreur', 'Impossible de récupérer les trajets: $e');
      }
    }
  }
}
