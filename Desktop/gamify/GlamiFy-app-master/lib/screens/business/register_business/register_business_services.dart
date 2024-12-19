import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../models/service_category.dart';
import '../../../services/stores_provider.dart';
import '../../auth/login_success/login_success_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterBusinessServices extends StatefulWidget {
  static String routeName = "/register_business_services";

  const RegisterBusinessServices({super.key});

  @override
  State<RegisterBusinessServices> createState() =>
      _RegisterBusinessServicesState();
}

class _RegisterBusinessServicesState extends State<RegisterBusinessServices> {
  double _scrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          setState(() {
            _scrollOffset = scrollInfo.metrics.pixels;
          });
          return true;
        },
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: _scrollOffset < 100
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [
                        kPrimaryColor,
                        Colors.blue.shade900,
                        kSecondaryColor,
                        kThirdColor,
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [Colors.white, Colors.white],
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
                        child: Text(
                          "Register Your Business",
                          style: TextStyle(
                            color: _scrollOffset < 100
                                ? Colors.white
                                : Colors.black,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: Text(
                          "Add Your Services",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _scrollOffset < 100
                                ? Colors.white
                                : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(30),
                    child: BusinessServicesForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BusinessServicesForm extends StatefulWidget {
  const BusinessServicesForm({super.key});

  @override
  _BusinessServicesFormState createState() => _BusinessServicesFormState();
}

class _BusinessServicesFormState extends State<BusinessServicesForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  final List<Map<String, dynamic>> _services = [];
  bool _isSubmitting = false;

  // Service form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  ServiceCategory? _selectedCategory;

  User? currentUser = FirebaseAuth.instance.currentUser;

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

  void _addService() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      setState(() {
        _services.add({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'duration': int.parse(_durationController.text),
          'category': _selectedCategory!.id,
        });

        // Clear form
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _durationController.clear();
        _selectedCategory = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Service Form
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
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Service Name",
                    hintText: "Enter service name",
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter service name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    hintText: "Enter service description",
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter service description";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: "Price (TND)",
                          hintText: "Enter price",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Please enter price";
                          }
                          if (double.tryParse(value!) == null) {
                            return "Please enter valid price";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: _durationController,
                        decoration: const InputDecoration(
                          labelText: "Duration (min)",
                          hintText: "Enter duration",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Please enter duration";
                          }
                          if (int.tryParse(value!) == null) {
                            return "Please enter valid duration";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Category Selection
                const Text(
                  "Select Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ServiceCategory.categories.length,
                    itemBuilder: (context, index) {
                      final category = ServiceCategory.categories[index];
                      final isSelected = _selectedCategory?.id == category.id;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                category.icon,
                                size: 24,
                                color: isSelected ? Colors.blue : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelected ? Colors.blue : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Add Service Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _addService,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Service'),
                  ),
                ),
              ],
            ),
          ),

          if (_services.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // Added Services List
            const Text(
              'Added Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    final service = _services[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          service['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service['description']),
                            Text(
                              '${service['price']} TND - ${service['duration']} min',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _services.removeAt(index);
                            });
                          },
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),
          FormError(errors: errors),

          if (_isSubmitting)
            const Center(child: CircularProgressIndicator())
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _services.isEmpty
                    ? null
                    : () async {
                        setState(() => _isSubmitting = true);
                        await saveServices();
                        setState(() => _isSubmitting = false);
                      },
                child: const Text("Complete Registration"),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> saveServices() async {
    try {
      await FirebaseFirestore.instance
          .collection('stores')
          .doc(currentUser!.uid)
          .update({
        'services': _services,
        'isProfileComplete': true,
      });

      if (mounted) {
        Provider.of<StoresProvider>(context, listen: false).refresh();
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginSuccessScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      print("Error saving services: $e");
      addError(error: "Error saving services. Please try again.");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
