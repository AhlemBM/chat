import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../otp/email/otp_email_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirmPassword;
  final List<String?> errors = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

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

  Future<void> signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        await userCredential.user?.sendEmailVerification();
        Navigator.pushNamed(context, OtpEmailScreen.routeName);

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          addError(error: 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          addError(error: 'The account already exists for that email.');
        } else {
          addError(error: 'An error occurred. Please try again.');
        }
      } catch (e) {
        print(e);
        addError(error: 'An unexpected error occurred. Please try again.');
      }
    }
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
              email = value;
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
            obscureText: _isPasswordObscure,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              password = value;
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
                  _isPasswordObscure ? Icons.lock : Icons.lock_open,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordObscure = !_isPasswordObscure;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: _isConfirmPasswordObscure,
            onSaved: (newValue) => confirmPassword = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (password == value) {
                removeError(error: kMatchPassError);
              }
              confirmPassword = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (password != value) {
                addError(error: kMatchPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Confirm Password",
              hintText: "Re-enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordObscure ? Icons.lock : Icons.lock_open,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                  });
                },
              ),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: signUpWithEmailAndPassword,
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
