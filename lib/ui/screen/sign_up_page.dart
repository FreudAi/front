import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  String cinFilePath = "";
  String bustFilePath = "";

  Future<void> _pickFile({required bool isCin}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        if (isCin) {
          cinFilePath = result.files.first.path!;
        } else {
          bustFilePath = result.files.first.path!;
        }
      });
    }
  }

  Future<void> _redirect (AuthState authState) async {
    if(authState.isAuthenticated) {
      await Future.delayed(const Duration(seconds: 1), () {
        Get.offNamed("/");
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final authState = Provider.of<AuthState>(context);

    _redirect(authState);

    return Scaffold(
      appBar: AppBar(
          title: const Text("S'inscrire à MadaRide"),
          backgroundColor: const Color(0xFF1D4ED8),
          foregroundColor: const Color(0xFFFFFFFF)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/image/logo.png',  // Chemin de l'image
                  width: 150,               // Largeur de l'image
                  height: 50,              // Hauteur de l'image
                  fit: BoxFit.contain,       // S'assurer que l'image est bien contenue
                ),
              ),
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(labelText: 'Nom complet'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(labelText: 'Adresse email'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'address',
                decoration: const InputDecoration(labelText: 'Adresse'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'phone_number',
                decoration: const InputDecoration(labelText: 'Numero de téléphone'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'password',
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              // CIN File Picker
              const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Scan du CIN', style: TextStyle(fontSize: 16),),
                  ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cinFilePath != "" ? cinFilePath : 'Sélectionner un fichier'),
                  ElevatedButton(
                    onPressed: () => _pickFile(isCin: true),
                    child: const Icon(Icons.upload_file),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Bust File Picker
              const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Photo buste de vous', style: TextStyle(fontSize: 16),),
                  ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(bustFilePath != "" ? bustFilePath : 'Sélectionner un fichier'),
                  ElevatedButton(
                    onPressed: () => _pickFile(isCin: true),
                    child: const Icon(Icons.upload_file),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      // Traitement de l'inscription
                      final formData = _formKey.currentState?.value;
                      /*print(formData);
                      print('CIN File: $cinFilePath');
                      print('Bust File: $bustFilePath');*/
                    } else {
                      print("Validation failed");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF1D4ED8),
                      foregroundColor: const Color(0xFFFFFFFF)),
                  child: const Text("S'inscrire"),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Vous avez un compte ?"),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(
                          '/login'); // Naviguer vers la page de connexion
                    },
                    child: const Text("Se connecter"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
