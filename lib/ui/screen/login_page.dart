import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:madaride/service/auth_service.dart';
import 'package:madaride/ui/screen/home_page.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../utils/auth_state.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final authService = AuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    final authState = Provider.of<AuthState>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text("Se connecter à MadaRide"),
          backgroundColor: const Color(0xFF1D4ED8),
          foregroundColor: const Color(0xFFFFFFFF)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding autour de toute la page
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                    const SizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'password',
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            final formData = _formKey.currentState!.value;
                            try {
                              final isLogin = await authService.login(
                                formData['email'],
                                formData['password'],
                              );
                              if (isLogin) {
                                final User user = await authService.profile();
                                authState.login(user);
                                Get.to(() => const MyHomePage());
                              } else {
                                Get.snackbar('Erreur', 'Invalid credentials');
                              }
                            } catch (e) {
                              Get.snackbar('Erreur', '$e');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: const Color(0xFF1D4ED8),
                            foregroundColor: const Color(0xFFFFFFFF)),
                        child: const Text('Se connecter'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nouveau?'),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(
                          '/sign-up'); // Navigation vers la page d'inscription
                    },
                    child: const Text("S'inscrire"),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Center(
                child: Column(
                  children: [
                    const Text('Ou se connecter avec'),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Connexion avec Google
                          },
                          icon: const Icon(Icons.login),
                          label: const Text('Google'),
                        ),
                        const SizedBox(width: 10.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Connexion avec Facebook
                          },
                          icon: const Icon(Icons.facebook),
                          label: const Text('Facebook'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
