import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../constants.dart';

class OtpForm extends StatefulWidget {
  final String phoneNumber; // Receive phone number as a parameter

  const OtpForm({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  String smsCode = '';
  List<FocusNode> _focusNodes = []; // Focus nodes for OTP inputs

  @override
  void initState() {
    super.initState();
    // Initialize focus nodes
    for (int i = 0; i < 4; i++) {
      _focusNodes.add(FocusNode());
    }
    sendOtp(); // Automatically send OTP on initialization
  }

  @override
  void dispose() {
    // Dispose of focus nodes to prevent memory leaks
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Method to send OTP to the provided phone number
  void sendOtp() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber, // Use the passed phone number
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.pushNamed(context, '/home'); // Navigate on success
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
        // Optionally, show a dialog or snackbar to inform the user
        _showErrorDialog('Verification failed. Please try again.');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId; // Store verification ID
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId; // Update verification ID
        });
      },
    );
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  // Method to verify the OTP
  void verifyOtp() async {
    if (smsCode.length == 4) { // Ensure the OTP is complete
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        await _auth.signInWithCredential(credential);
        Navigator.pushNamed(context, '/home'); // Navigate to home on success
      } catch (e) {
        print('Error verifying OTP: $e'); // Better error logging
        _showErrorDialog('Error verifying OTP. Please try again.'); // Show error dialog
      }
    } else {
      print("OTP code is not complete"); // Log incomplete OTP
      _showErrorDialog('Please enter a complete OTP code.'); // Inform user
    }
  }

  // Method to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < 4; i++) // Create 4 input fields for the OTP
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        smsCode += value; // Concatenate the input
                        if (i < 3) nextField(value, _focusNodes[i + 1]); // Move to next field
                      }
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    focusNode: _focusNodes[i],
                    decoration: otpInputDecoration, // Your input decoration here
                  ),
                ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: verifyOtp,
            child: const Text('Verify OTP'),
          ),
        ],
      ),
    );
  }
}
