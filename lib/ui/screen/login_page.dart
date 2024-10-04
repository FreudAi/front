import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:madaride/service/auth_service.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../utils/auth_state.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final authService = AuthService();

  LoginPage({super.key});

  Future<void> _redirect(AuthState authState) async {
    if (authState.isAuthenticated) {
      await Future.delayed(const Duration(seconds: 1), () {
        Get.offNamed("/");
      });
    }
  }

  Future<void> _redirectAfterLogin(AuthState authState) async {
    if (authState.redirectAfterLogin != "") {
      String path = authState.redirectAfterLogin;
      authState.redirectAfterLogin = "";
      await Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed(path);
      });
    } else {
      await Future.delayed(const Duration(seconds: 1), () {
        Get.toNamed("/");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = Provider.of<AuthState>(context);

    _redirect(authState);

    return Scaffold(
      appBar: AppBar(
          title: const Text("Se connecter"),
          backgroundColor: const Color(0xFF1D4ED8),
          foregroundColor: const Color(0xFFFFFFFF)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ajout de l'image en haut
              Padding(
                padding: const EdgeInsets.only(bottom: 26.0),
                child: Image.asset(
                  'assets/image/logo.png',  // Chemin de l'image
                  width: 150,               // Largeur de l'image
                  height: 50,              // Hauteur de l'image
                  fit: BoxFit.contain,       // S'assurer que l'image est bien contenue
                ),
              ),
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
                          if (_formKey.currentState?.saveAndValidate() ?? false) {
                            final formData = _formKey.currentState!.value;
                            try {
                              final isLogin = await authService.login(
                                formData['email'],
                                formData['password'],
                              );
                              if (isLogin) {
                                final User user = await authService.profile();
                                authState.login(user);
                                _redirectAfterLogin(authState);
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
                          foregroundColor: const Color(0xFFFFFFFF),
                        ),
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
                      Get.toNamed('/sign-up');
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
