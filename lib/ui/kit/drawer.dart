import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madaride/ui/screen/home_page.dart';
import 'package:madaride/ui/screen/login_page.dart';
import 'package:madaride/ui/screen/sign_up_page.dart';
import 'package:provider/provider.dart';

import '../../utils/auth_state.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'MadaRide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Rechercher trajet'),
              onTap: () {
                Get.off(const MyHomePage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Se connecter'),
              onTap: () {
                Get.to(LoginPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('S\'inscrire'),
              onTap: () {
                Get.to(SignUpPage());
              },
            ),
          ],
        ),
      );
  }
}
