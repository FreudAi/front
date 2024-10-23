import 'package:flutter/material.dart';
import 'package:madaride/utils/function.dart';
import 'package:stripe_native_card_field/stripe_native_card_field.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int numberOfSeats = 1;
  int availableSeats = 4; // Exemple de données disponibles
  double pricePerSeat = 15000.0; // Prix par place
  double totalAmount = 15000.0; // Montant total à payer
  bool isCardSelected = true; // Mode de paiement sélectionné
  bool loading = false;
  String error = '';

  void incrementSeats() {
    if (numberOfSeats < availableSeats) {
      setState(() {
        numberOfSeats++;
        totalAmount = numberOfSeats * pricePerSeat;
      });
    }
  }

  void decrementSeats() {
    if (numberOfSeats > 1) {
      setState(() {
        numberOfSeats--;
        totalAmount = numberOfSeats * pricePerSeat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texte Antsirabe vers Antananarivo sur une seule ligne
            const Text(
              'Antsirabe vers Antananarivo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            // Date avec "Le" et format d'heure
            const Text(
              'Le 10 octobre 2024 à 07:00',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Places disponibles
            Text(
              '$availableSeats places disponibles',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Gestion des erreurs
            if (error.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Sélection du nombre de places
            const Text('Nombre de places à réserver :', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Row(
              children: [
                // Boutons plus visibles et texte agrandi
                IconButton(
                  onPressed: decrementSeats,
                  icon: const Icon(Icons.remove, size: 30, color: Colors.red),
                ),
                Text(
                  '$numberOfSeats',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: incrementSeats,
                  icon: const Icon(Icons.add, size: 30, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Montant à payer
            const Text(
              'Montant à payer :',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '${formatPrice(totalAmount)} MGA',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Mode de paiement côte à côte
            const Text('Mode de paiement :', style: TextStyle(fontSize: 16),),
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: isCardSelected,
                      onChanged: (value) {
                        setState(() {
                          isCardSelected = true;
                        });
                      },
                    ),
                    const Text('Carte bancaire'),
                  ],
                ),
                const SizedBox(width: 20), // Espacement entre les deux options
                Row(
                  children: [
                    Radio(
                      value: false,
                      groupValue: isCardSelected,
                      onChanged: (value) {
                        setState(() {
                          isCardSelected = false;
                        });
                      },
                    ),
                    const Text('Mobile money'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Affichage des détails de paiement selon le mode sélectionné
            if (isCardSelected)
            // Champ pour carte bancaire
              CardTextField(
                width: 360,
                onValidCardDetails: (details) {
                  // Gérer les détails de la carte
                },
              ),
            if (!isCardSelected)
              const SizedBox(
                height: 50,
                child: Center(child: Text('Entrer les informations de Mobile Money')),
              ),
            const SizedBox(height: 20),

            // Bouton de paiement
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () {
                // Logique de réservation ici
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF1D4ED8),
                  foregroundColor: const Color(0xFFFFFFFF)),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Payer'),
            ),
          ],
        ),
      ),
    );
  }
}
