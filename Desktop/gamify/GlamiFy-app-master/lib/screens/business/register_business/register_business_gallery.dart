import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glamify_app/screens/business/register_business/register_business_services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class RegisterBusinessGallery extends StatelessWidget {
  static String routeName = "/register_business_gallery";

  const RegisterBusinessGallery({super.key});

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
                      "Add Your Business Gallery",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: const SingleChildScrollView(
                  padding: EdgeInsets.all(30),
                  child: BusinessGalleryForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessGalleryForm extends StatefulWidget {
  const BusinessGalleryForm({super.key});

  @override
  _BusinessGalleryFormState createState() => _BusinessGalleryFormState();
}

class _BusinessGalleryFormState extends State<BusinessGalleryForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

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

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    setState(() {
      _selectedImages.addAll(images.map((image) => File(image.path)));
    });
    }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Gallery Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Business Gallery',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Add photos of your work to showcase your services',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add Photos'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_selectedImages.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(_selectedImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () => _removeImage(index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Form Error Display and Submit Button
          FormError(errors: errors),
          if (_isUploading)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: _selectedImages.isEmpty
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isUploading = true);
                        await saveGallery(currentUser!.uid);
                        setState(() => _isUploading = false);
                      }
                    },
              child: const Text("Continue to upload"),
            ),
        ],
      ),
    );
  }

  Future<void> saveGallery(String uid) async {
    try {
      List<String> imageUrls = [];

      // Upload images to Firebase Storage
      for (var imageFile in _selectedImages) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('business_gallery/$uid/$fileName');

        await ref.putFile(imageFile);
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Save image URLs to Firestore
      await FirebaseFirestore.instance.collection('stores').doc(uid).update({
        'gallery': imageUrls
      });

      if (mounted) {
        Navigator.pushNamed(context, RegisterBusinessServices.routeName);
      }
    } catch (e) {
      print("Error saving gallery: $e");
      addError(error: "Error saving gallery. Please try again.");
    }
  }
}
