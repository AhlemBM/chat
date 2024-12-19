import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../constants.dart';
import '../../complete_profile/complete_profile_screen.dart';

class OtpEmailScreen extends StatelessWidget {
  static String routeName = "/otp";

  const OtpEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? email = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              color: Colors.green,
              size: 80,
            ),
            const Text(
              "Verification Email Sent",
              style: headingStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "We sent a verification email to $email. Please check your inbox and verify your email.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Resend verification email logic
                User? user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Verification email resent")),
                );
              },
              child: const Text("Resend Verification Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Check if the user is verified
                User? user = FirebaseAuth.instance.currentUser;
                await user?.reload(); // Refresh user state
                user = FirebaseAuth.instance.currentUser; // Get the updated user

                if (user != null && user.emailVerified) {
                  // Navigate to the login success screen
                  Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email not verified yet")),
                  );
                }
              },
              child: const Text("Check Email Verification"),
            ),
          ],
        ),
      ),
    );
  }
}
