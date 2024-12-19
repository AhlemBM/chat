import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glamify_app/screens/business/register_business/register_work_schedule.dart';

import '../../../components/category_card.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../auth/complete_profile/PhoneInputFormatter.dart';

class RegisterBusinessScreen extends StatelessWidget {
  static String routeName = "/register_business";

  const RegisterBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              kPrimaryColor,
              Colors.blue.shade900,
              kSecondaryColor,
              kThirdColor,
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
                    child: const Text(
                      "Register Your Business",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: const Text(
                      "Complete Your Business Account",
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
                child: const SingleChildScrollView(
                  padding: EdgeInsets.all(30),
                  child: RegisterBusinessForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterBusinessForm extends StatefulWidget {
  const RegisterBusinessForm({super.key});

  @override
  _RegisterBusinessFormState createState() => _RegisterBusinessFormState();
}

class _RegisterBusinessFormState extends State<RegisterBusinessForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];

  List<Map<String, dynamic>> categories = [
    {"icon": "assets/icons/short-hair-and-scissors.svg", "text": "Men"},
    {"icon": "assets/icons/woman-hair-cut-svgrepo-com.svg", "text": "Women"},
    {"icon": "assets/icons/Discover.svg", "text": "All"},
  ];

  String? businessName;
  String? mobileNumber;
  String? location;
  String? clientType = "Men";

  // Get current user from Firebase Auth
  User? currentUser = FirebaseAuth.instance.currentUser;

  void addError({String? error}) {
    if (error != null && !errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (error != null && errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Business Name
          TextFormField(
            onSaved: (newValue) => businessName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) removeError(error: kNamelNullError);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Business Name",
              hintText: "Enter your Business name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person_2_outlined),
            ),
          ),
          const SizedBox(height: 20),

          // Mobile Number
          TextFormField(
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneInputFormatter()],
            onSaved: (newValue) => mobileNumber = "+216 $newValue",
            onChanged: (value) {
              if (value.isNotEmpty && value.length == 10) {
                removeError(error: "Phone number should be 8 digits");
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: "Phone number is required");
                return "";
              } else if (value.replaceAll(' ', '').length != 8) {
                addError(error: "Phone number should be 8 digits");
                return "Phone number should be 8 digits";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Phone Number",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/tn_flag.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text("+216"),
                  ],
                ),
              ),
              suffixIcon: const Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 20),

          // Location
          TextFormField(
            onSaved: (newValue) => location = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) removeError(error: kAddressNullError);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Location",
              hintText: "Enter your location",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 20),

          // Client Type
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text(
                    'Client Type',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      categories.length,
                          (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: CategoryCard(
                          icon: categories[index]["icon"],
                          text: categories[index]["text"],
                          isSelected: clientType == categories[index]["text"],
                          press: () {
                            setState(() {
                              clientType = categories[index]["text"];
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Form Error Display and Submit Button
          FormError(errors: errors),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                if (currentUser == null) {
                  addError(error: "User not found.");
                  return;
                }

                await saveStore(currentUser!.uid);

                Navigator.pushNamed(context, RegisterWorkSchedule.routeName);
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  Future<void> saveStore(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('stores').doc(uid).set({
        'businessName': businessName,
        'mobileNumber': mobileNumber,
        'location': location,
        'clientType': clientType,
        'isProfileComplete': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pushNamed(context, RegisterWorkSchedule.routeName);
      }
    } catch (e) {
      print("Error saving Store Information: $e");
      addError(error: "Error saving Store Information. Please try again.");
    }
  }
}