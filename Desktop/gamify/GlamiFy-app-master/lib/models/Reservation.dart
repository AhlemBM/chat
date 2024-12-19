import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation with ChangeNotifier {
  final String id;
  DateTime agenda; // Date et heure de la réservation
  //String note; // Notes supplémentaires
  Map<String, dynamic> staff; // Détails du staff
  Map<String, dynamic> service; // Détails du service
//  double cost; // Coût total
  String commentaire; // commentaire optionnelle
//  String image; // Image associée à la réservation

  Reservation({
    required this.id,
    required this.agenda,
    //required this.note,
    required this.staff,
    required this.service,
    //required this.cost,
    required this.commentaire,
    //required this.image,
  });

  // Factory pour créer une réservation depuis Firestore
  factory Reservation.fromFirestore(Map<String, dynamic> data, String id) {
    return Reservation(
      id: id,
      agenda: (data['agenda'] as Timestamp).toDate(),
     // note: data['note'] ?? '',
      staff: Map<String, dynamic>.from(data['staff'] ?? {}),
      service: Map<String, dynamic>.from(data['service'] ?? {}),
      // cost: (data['cost'] as num?)?.toDouble() ?? 0.0,
      commentaire: data['commentaire'] ?? '',
      // image: data['image'] ?? '',
    );
  }

  // Méthode pour charger une réservation depuis Firestore
  Future<void> loadReservationData() async {
    try {
      DocumentSnapshot reservationDoc = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(id)
          .get();

      if (reservationDoc.exists) {
        agenda = (reservationDoc['agenda'] as Timestamp).toDate();
        //note = reservationDoc['note'] ?? '';
        staff = Map<String, dynamic>.from(reservationDoc['staff'] ?? {});
        service = Map<String, dynamic>.from(reservationDoc['service'] ?? {});
        // cost = (reservationDoc['cost'] as num?)?.toDouble() ?? 0.0;
        commentaire = reservationDoc['commentaire'] ?? '';
        //image = reservationDoc['image'] ?? '';

        notifyListeners();
      } else {
        print("Reservation document does not exist in Firestore.");
      }
    } catch (e) {
      print("Error fetching reservation document: $e");
    }
  }

  // Méthode statique pour charger toutes les réservations
  static Future<List<Reservation>> loadAllReservations() async {
    List<Reservation> reservations = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('reservations').get();

      for (var doc in querySnapshot.docs) {
        reservations.add(Reservation.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      print("Error fetching reservations: $e");
    }
    return reservations;
  }

  // Méthode pour ajouter une réservation dans Firestore
  Future<void> addReservation() async {
    try {
      // Créer un document dans la collection "reservations"
      await FirebaseFirestore.instance.collection('reservations').add({
        'agenda': agenda, // Date et heure de la réservation
       // 'note': note, // Commentaire
        'staff': staff, // Détails du staff
        'service': service, // Détails du service
        // 'cost': cost, // Coût de la réservation
        'commentaire': commentaire, // commentaire optionnelle
        //'image': image, // Image associée à la réservation
      });

      print('Réservation ajoutée avec succès');
    } catch (e) {
      print("Erreur lors de l'ajout de la réservation: $e");
    }
  }
}

