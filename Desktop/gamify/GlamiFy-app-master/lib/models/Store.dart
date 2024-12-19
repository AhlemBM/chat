import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store with ChangeNotifier {
  final String id;
  String businessName;
  String clientType;
  DateTime createdAt;
  List<String> gallery;
  bool isProfileComplete;
  String location;
  String mobileNumber;
  List<Map<String, dynamic>> services;
  Map<String, dynamic> workSchedule;

  Store({
    required this.id,
    required this.businessName,
    required this.clientType,
    required this.createdAt,
    required this.gallery,
    required this.isProfileComplete,
    required this.location,
    required this.mobileNumber,
    required this.services,
    required this.workSchedule,
  });

  factory Store.fromFirestore(Map<String, dynamic> data, String id) {
    return Store(
      id: id,
      businessName: data['businessName'] ?? '',
      clientType: data['clientType'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      gallery: List<String>.from(data['gallery'] ?? []),
      isProfileComplete: data['isProfileComplete'] ?? false,
      location: data['location'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      services: List<Map<String, dynamic>>.from(data['services'] ?? []),
      workSchedule: Map<String, dynamic>.from(data['workSchedule'] ?? {}),
    );
  }

  Future<void> loadStoreData() async {
    try {
      DocumentSnapshot storeDoc =
          await FirebaseFirestore.instance.collection('stores').doc(id).get();

      if (storeDoc.exists) {
        businessName = storeDoc['businessName'] ?? '';
        clientType = storeDoc['clientType'] ?? '';
        createdAt = (storeDoc['createdAt'] as Timestamp).toDate();
        gallery = List<String>.from(storeDoc['gallery'] ?? []);
        isProfileComplete = storeDoc['isProfileComplete'] ?? false;
        location = storeDoc['location'] ?? '';
        mobileNumber = storeDoc['mobileNumber'] ?? '';
        services = List<Map<String, dynamic>>.from(storeDoc['services'] ?? []);
        workSchedule =
            Map<String, dynamic>.from(storeDoc['workSchedule'] ?? {});

        notifyListeners();
      } else {
        print("Store document does not exist in Firestore.");
      }
    } catch (e) {
      print("Error fetching store document: $e");
    }
  }

  static Future<List<Store>> loadAllStores() async {
    List<Store> stores = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('stores').get();

      for (var doc in querySnapshot.docs) {
        stores.add(
            Store.fromFirestore(doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      print("Error fetching stores: $e");
    }
    return stores;
  }
}
