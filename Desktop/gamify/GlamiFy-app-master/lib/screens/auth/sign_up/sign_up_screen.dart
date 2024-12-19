import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/socal_card.dart';
import '../../../services/auth_service.dart';
import 'sign_up_form.dart';


class SignUpScreen extends StatefulWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false; // State variable for loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading // Conditional rendering for loading indicator
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                  const SizedBox(height: 10),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: const Text(
                      "create your account",
                      textAlign: TextAlign.center,
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
                      const SignUpForm(),
                      const SizedBox(height: 50),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Divider(color: Colors.black54)),
                              const SizedBox(width: 10),
                              const Text("Or Sign up with", style: TextStyle(color: Colors.black54)),
                              const SizedBox(width: 10),
                              Expanded(child: Divider(color: Colors.black54)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocalCard(
                                icon: "assets/icons/google-icon.svg",
                                press: (){
                                  // Accessing the AuthService from the provider
                                  Provider.of<AuthService>(context, listen: false).signInWithGoogle(context);
                                },
                              ),
                              const SizedBox(width: 20),
                              SocalCard(
                                icon: "assets/icons/facebook-2.svg",
                                press: () {}, // Facebook Sign-In logic
                              ),
                              const SizedBox(width: 20),
                              SocalCard(
                                icon: "assets/icons/twitter.svg",
                                press: () {}, // Twitter Sign-In logic
                              ),
                            ],
                          ),
                        ],
                      ),
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
