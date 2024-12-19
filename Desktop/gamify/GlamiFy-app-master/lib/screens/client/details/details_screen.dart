import 'package:flutter/material.dart';
import '../../../../models/Store.dart';
import '../../../models/service_category.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "/details";

  const DetailsScreen({super.key});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String currentSection = "Services"; // Section active par défaut

  bool isStoreOpen(Map<String, dynamic> workSchedule) {
    final now = DateTime.now();
    final currentDay = DateFormat('EEEE').format(now); // Jour actuel
    final currentTime = now.hour * 60 + now.minute; // Temps actuel en minutes

    // Extraction des données horaires
    final startDay = workSchedule['startDay'];
    final endDay = workSchedule['endDay'];
    final startTime = _convertTimeToMinutes(workSchedule['startTime']);
    final endTime = _convertTimeToMinutes(workSchedule['endTime']);
    final restStartTime = _convertTimeToMinutes(workSchedule['restStartTime']);
    final restEndTime = _convertTimeToMinutes(workSchedule['restEndTime']);

    // Vérifier si le magasin est ouvert aujourd'hui
    final isTodayOpen = _isWithinDays(currentDay, startDay, endDay);

    if (!isTodayOpen) return false;

    // Vérifier si l'heure actuelle se situe dans les plages d'ouverture
    return (currentTime >= startTime && currentTime < restStartTime) ||
        (currentTime >= restEndTime && currentTime < endTime);
  }

  bool _isWithinDays(String currentDay, String startDay, String endDay) {
    const weekDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    final startIndex = weekDays.indexOf(startDay);
    final endIndex = weekDays.indexOf(endDay);
    final currentIndex = weekDays.indexOf(currentDay);

    if (startIndex <= endIndex) {
      return currentIndex >= startIndex && currentIndex <= endIndex;
    } else {
      return currentIndex >= startIndex || currentIndex <= endIndex;
    }
  }

  int _convertTimeToMinutes(String time) {
    final timeParts = time.split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    return hours * 60 + minutes;
  }

  @override
  Widget build(BuildContext context) {
    final StoreDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as StoreDetailsArguments;

    final isOpen = isStoreOpen(args.store.workSchedule);

    return Scaffold(
      appBar: AppBar(
        title: Text(args.store.businessName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image principale avec bouton Open/Closed et icônes
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image.network(
                    args.store.gallery.isNotEmpty
                        ? args.store.gallery[0]
                        : 'https://via.placeholder.com/400',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              Icon(Icons.favorite_border, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOpen ? Colors.green : Colors.red,
                        ),
                        child: Text(
                          isOpen ? 'Open' : 'Closed',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Nom du magasin et les étoiles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      args.store.businessName,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < 3 ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Description
              Text(
                'Description du magasin: ${args.store.businessName}',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              // Localisation et horaires
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        args.store.location,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        "${args.store.workSchedule['startTime']} - ${args.store.workSchedule['endTime']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Catégories de services
              const SizedBox(height: 20),
              Text(
                'Service Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16.0, // Espacement entre les éléments
                runSpacing: 8.0, // Espacement vertical
                children: ServiceCategory.categories.map((category) {
                  return Chip(
                    avatar: Icon(category.icon),
                    label: Text(category.name),
                    labelStyle: const TextStyle(fontSize: 16),
                    backgroundColor: Colors.blue.shade50,
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Boutons sous la localisation et les horaires sur deux lignes
              Column(
                children: [
                  // Ligne 1 avec les deux premiers boutons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Bouton pour Services
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentSection = "Services";
                            });
                          },
                          child: Text('Services'),
                        ),
                      ),
                      // Bouton pour Staff
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentSection = "Staff";
                            });
                          },
                          child: Text('Staff'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Espacement entre les lignes

                  // Ligne 2 avec les deux autres boutons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Bouton pour Avis
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentSection = "Avis";
                            });
                          },
                          child: Text('Avis'),
                        ),
                      ),
                      // Bouton pour Offres
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentSection = "Offres";
                            });
                          },
                          child: Text('Offres'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Titre Categories
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Sections
              if (currentSection == "Services")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Services proposés par ${args.store.businessName}:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...args.store.services.map((service) {
                      // Extraction du nom, prix, durée de chaque service
                      String serviceName = service['name'] ?? 'Service inconnu';
                      String servicePrice =
                          service['price']?.toString() ?? 'Prix non disponible';
                      String serviceDuration =
                          service['duration']?.toString() ?? 'Durée non disponible';
                      return ListTile(
                        leading: Icon(Icons.check, color: Colors.green),
                        title: Text(serviceName),
                        subtitle: Text(
                            'Prix: \$${servicePrice} - Durée: ${serviceDuration} min'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () {
                            // Naviguer vers la page Reservation en passant les détails du service
                            Navigator.pushNamed(
                              context,
                              '/reservation',
                              arguments: {
                                'service': service,
                                'storeName': args.store.businessName,
                              },
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              if (currentSection == "Staff") Text('Staff details here...'),
              if (currentSection == "Avis") Text('Avis details here...'),
              if (currentSection == "Offres") Text('Offres details here...'),
            ],
          ),
        ),
      ),
    );
  }
}

// Classe pour passer les arguments du store
class StoreDetailsArguments {
  final Store store;

  StoreDetailsArguments({required this.store});
}
