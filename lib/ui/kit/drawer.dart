import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madaride/service/auth_service.dart';
import 'package:madaride/ui/screen/booking_page.dart';
import 'package:madaride/ui/screen/home_page.dart';
import 'package:madaride/ui/screen/login_page.dart';
import 'package:madaride/ui/screen/profile_page.dart';
import 'package:madaride/ui/screen/sign_up_page.dart';
import 'package:provider/provider.dart';

import '../../utils/auth_state.dart';

class RightDrawer extends StatelessWidget {
  final AuthService authService = AuthService();

  RightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(authState),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Rechercher trajet'),
            onTap: () {
              Get.off(const MyHomePage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Réservations'),
            onTap: () {
              Get.to(() => const BookingPage());
            },
          ),
          if (authState.isAuthenticated) ...[
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Réservations'),
              onTap: () {
                Get.to(() => const BookingPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_road),
              title: const Text('Mes trajets'),
              onTap: () {
                Get.to(() => const ProfilePage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Véhicules'),
              onTap: () {
                Get.to(() => const ProfilePage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Préférences'),
              onTap: () {
                Get.to(() => const ProfilePage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mon compte'),
              onTap: () {
                Get.to(() => const ProfilePage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Se déconnecter'),
              onTap: () {
                authService.logout();
                authState.logout();
                Get.offAll(() => LoginPage());
              },
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Se connecter'),
              onTap: () {
                Get.to(() => LoginPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('S\'inscrire'),
              onTap: () {
                Get.to(() => const SignUpPage());
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(AuthState authState) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: authState.isAuthenticated
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage("http://172.20.10.9:8000/storage/${authState.user.bustFile}"),
            radius: 30,
          ),
          const SizedBox(height: 10),
          Text(
            authState.user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            authState.user.email,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      )
          : Image.asset(
            'assets/image/logo.png',
            width: 100,
            height: 50,
          )
    );
  }
}
