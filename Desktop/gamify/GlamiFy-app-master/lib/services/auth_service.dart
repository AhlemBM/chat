import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/auth/complete_profile/complete_profile_screen.dart';
import '../screens/auth/login_success/login_success_screen.dart';




class AuthService with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // If sign-in was aborted

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User user = userCredential.user!;

      // Check Firestore for `isProfileComplete` status
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // New user - initialize profile in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstName': user.displayName?.split(" ")[0] ?? "",
          'lastName': user.displayName!.split(" ").length > 1 ? user.displayName?.split(" ")[1] : "",
          'email': user.email,
          'isProfileComplete': false, // Set to false by default
        });
        Navigator.pushNamed(context, CompleteProfileScreen.routeName);
      } else {
        // Existing user - check profile completion status
        bool isProfileComplete = userDoc['isProfileComplete'] ?? false;
        if (isProfileComplete) {
          Navigator.pushNamed(context, LoginSuccessScreen.routeName);
        } else {
          Navigator.pushNamed(context, CompleteProfileScreen.routeName);
        }
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-in failed. Please try again.")),
      );
    }
  }

  void signInWithFacebook(BuildContext context) {}
}
