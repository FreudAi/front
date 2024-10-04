import 'package:intl/intl.dart';

String formatPrice(double price) {
  final formatter = NumberFormat('#,##0', 'fr_FR');
  return formatter.format(price);
}

String formatDate(String dateString) {
  // Convertir la chaîne en objet DateTime
  DateTime dateTime = DateTime.parse(dateString);

  // Définir le format désiré
  final DateFormat formatter = DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR');

  // Retourner la date formatée
  return formatter.format(dateTime);
}

String getFirstElement(String text) {
  // Split le texte par la virgule et retourne le premier élément
  return text.split(',')[0].trim();
}
