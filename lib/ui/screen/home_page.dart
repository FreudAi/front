import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:madaride/ui/kit/drawer.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  double _nombrePlaces = 1;

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

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
      endDrawer: RightDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (authState.isAuthenticated) {
            await Future.delayed(const Duration(seconds: 1), () {
              Get.toNamed("/publish-ride");
            });
          } else {
            await Future.delayed(const Duration(seconds: 1), () {
              authState.redirectAfterLogin = "/publish-ride";
              Get.toNamed("/login");
            });
          }
        },
        tooltip: 'Publish ride',
        backgroundColor: const Color(0xFF5683FF),
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
            keyboardType: TextInputType.text, // Utilisation du clavier texte
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Lieu de départ',
              prefixIcon: Icon(Icons.location_on, color: Colors.indigo,),
              //border: OutlineInputBorder(),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          const SizedBox(height: 12),
          FormBuilderTextField(
            name: 'arrivee',
            keyboardType: TextInputType.text, // Utilisation du clavier texte
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: "Lieu d'arrivée",
              prefixIcon: Icon(Icons.flag, color: Colors.green),
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
              prefixIcon: Icon(Icons.calendar_today, color: Colors.amber),
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
              max: 4,
              divisions: 3,
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

  void _onSearchPressed() {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;
      var parameters = <String, String>{
        "depart": formData['depart'],
        "arrive": formData['arrivee'],
        "date": formData["date"].toString(),
        "places": _nombrePlaces.round().toString()
      };
      Get.toNamed("/search-result", parameters: parameters);
    }
  }
}
