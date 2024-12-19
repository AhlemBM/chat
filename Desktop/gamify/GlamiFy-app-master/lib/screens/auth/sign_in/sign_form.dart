import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../complete_profile/complete_profile_screen.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../login_success/login_success_screen.dart';


class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  bool _isObscure = true;
  final List<String?> errors = [];

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // Check if email is verified
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        // If not verified, show message and sign them out
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please verify your email to continue.'),
          ),
        );

        // Optionally, prompt them to resend the verification email
        await userCredential.user!.sendEmailVerification();
        return; // Exit the function after showing the message
      }

      // Now check if user exists in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // If user document does not exist, navigate to CompleteProfileScreen
        Navigator.pushNamed(context, CompleteProfileScreen.routeName);
      } else {
        // Check if the profile is complete
        bool isProfileComplete = userDoc['isProfileComplete'] ?? false;

        if (!isProfileComplete) {
          // If profile is not complete, navigate to CompleteProfileScreen
          Navigator.pushNamed(context, CompleteProfileScreen.routeName);
        } else {
          // If verified and profile is complete, navigate to success page
          Navigator.pushNamed(context, LoginSuccessScreen.routeName);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        addError(error: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        addError(error: 'Wrong password provided.');
      } else {
        addError(error: 'An error occurred. Please try again.');
      }
    } catch (e) {
      print(e);
      addError(error: 'An unexpected error occurred. Please try again.');
    }
  }




  void togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: _isObscure,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.lock : Icons
                      .lock_open, // Changes icon based on state
                ),
                onPressed: togglePasswordView, // Toggles password visibility
              ),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Hide keyboard
                KeyboardUtil.hideKeyboard(context);

                // Sign in the user
                await signInWithEmailAndPassword(context);
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}