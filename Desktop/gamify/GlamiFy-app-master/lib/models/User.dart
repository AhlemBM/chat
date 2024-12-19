import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel with ChangeNotifier {
  String firstName = "User";
  String lastName = "";
  String email = "";
  String mobileNumber = "";
  String location = "";
  bool isStaff = false;
  bool isBusiness = false;
  bool hasStore = false;

  // Method to load user profile from Firestore
  Future<void> loadUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        email = currentUser.email ?? "";
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          firstName = userDoc['firstName'] ?? "";
          lastName = userDoc['lastName'] ?? "";
          mobileNumber = userDoc['phoneNumber'] ?? "";
          location = userDoc['address'] ?? "";
          isStaff = userDoc['isStaff'] ?? false;
          isBusiness = userDoc['isBusiness'] ?? false;

          // Check if the user has a registered store
          await checkStoreRegistration(currentUser.uid);

          notifyListeners(); // Notify listeners of state change
        } else {
          print("User document does not exist in Firestore.");
        }
      } catch (e) {
        print("Error fetching user document: $e");
      }
    } else {
      print("No current user found.");
    }
  }

  // Method to check if a business user has registered a store
  Future<void> checkStoreRegistration(String userId) async {
    try {
      DocumentSnapshot storeDoc = await FirebaseFirestore.instance
          .collection('stores') // Assuming 'stores' is the collection for registered stores
          .doc(userId)
          .get();

      hasStore = storeDoc['isProfileComplete'];
    } catch (e) {
      print("Error checking store registration: $e");
      hasStore = false;
    }
  }

  // Method to reset user data
  void resetUserData() {
    firstName = "User";
    lastName = "";
    email = "";
    mobileNumber = "";
    location = "";
    isStaff = false;
    isBusiness = false;
    hasStore = false; // Reset hasStore as well
    notifyListeners(); // Notify listeners of state change
  }
}
