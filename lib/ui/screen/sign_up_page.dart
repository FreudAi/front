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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(labelText: 'Name'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(labelText: 'Email'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'address',
                decoration: const InputDecoration(labelText: 'Address'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'phone_number',
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'password',
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              // CIN File Picker
              const Text('CIN File'),
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
              const Text('Bust File'),
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
                      print(formData);
                      print('CIN File: $cinFilePath');
                      print('Bust File: $bustFilePath');
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
