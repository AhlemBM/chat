import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:glamify_app/screens/auth/sign_in/sign_form.dart';
import 'package:provider/provider.dart';

import '../../../components/no_account_text.dart';
import '../../../components/socal_card.dart';
import '../../../services/auth_service.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0e1d42),
              Colors.blue,
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: const Text(
                      "Enter your credential to login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      const SignForm(),
                      const SizedBox(height: 50),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Divider(color: Colors.black54)),
                              const SizedBox(width: 10), // Space between divider and text
                              const Text("Or Sign in with", style: TextStyle(color: Colors.black54)),
                              const SizedBox(width: 10), // Space between text and divider
                              Expanded(child: Divider(color: Colors.black54)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocalCard(
                                icon: "assets/icons/google-icon.svg",
                                press: () {
                                  Provider.of<AuthService>(context, listen: false).signInWithGoogle(context);
                                },
                              ),
                              const SizedBox(width: 20), // Space between icons
                              SocalCard(
                                icon: "assets/icons/facebook-2.svg",
                                press: () {
                                  Provider.of<AuthService>(context, listen: false).signInWithFacebook(context);
                                },
                              ),
                              const SizedBox(width: 20), // Space between icons
                              SocalCard(
                                icon: "assets/icons/twitter.svg",
                                press: () {}, // Twitter Sign-In logic here
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const NoAccountText(),
                      const SizedBox(height: 20),
                      Text(
                        'By continuing you confirm that you agree \nwith our Terms and Conditions',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
