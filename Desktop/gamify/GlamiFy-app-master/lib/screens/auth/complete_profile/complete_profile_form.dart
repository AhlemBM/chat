import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'package:image_picker/image_picker.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../login_success/login_success_screen.dart';
import 'PhoneInputFormatter.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key});

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];

  // Fields to capture user input
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  XFile? _image; // Variable to hold the selected image

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

  Future<String?> _uploadImageToFirebase(XFile image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${currentUser?.uid}');
      await storageRef.putFile(File(image.path));
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      addError(error: "Error uploading image. Please try again.");
      return null;
    }
  }

  Future<void> saveUserProfile(String uid) async {
    String? avatarUrl;
    if (_image != null) {
      avatarUrl = await _uploadImageToFirebase(_image!);
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'address': address,
        'avatarUrl': avatarUrl,
        'isStaff': false,
        'isBusiness': false,
        'isProfileComplete': true,
      });
    } catch (e) {
      print("Error saving user profile: $e");
      addError(error: "Error saving user profile. Please try again.");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage; // Update state with the selected image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage, // Open image picker on tap
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _image != null
                  ? FileImage(File(_image!.path))
                  : null, // Display selected image
              child: _image == null
                  ? const Icon(
                Icons.camera_alt,
                size: 40,
                color: Colors.white,
              )
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickImage, // Trigger image picker on text tap
            child: const Text(
              "Change Profile Picture",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) removeError(error: kNamelNullError);
              return;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "First Name",
              hintText: "Enter your first name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person_2_outlined),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => lastName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) removeError(error: kNamelNullError);
              return;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Last Name",
              hintText: "Enter your last name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person_2_outlined),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneInputFormatter()],
            onSaved: (newValue) => phoneNumber = "+216 $newValue",
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
          TextFormField(
            onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) removeError(error: kAddressNullError);
              return;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Address",
              hintText: "Enter your address",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(
                  Icons.location_on_outlined), // Replaced with Material Icon
            ),
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                if (currentUser == null) {
                  addError(error: "User not found.");
                  return;
                }

                await saveUserProfile(currentUser!.uid);

                Navigator.pushNamed(context, LoginSuccessScreen.routeName);
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
