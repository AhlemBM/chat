import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glamify_app/screens/business/register_business/register_business_gallery.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class RegisterWorkSchedule extends StatelessWidget {
  static String routeName = "/register_work_schedule";

  const RegisterWorkSchedule({super.key});

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
                      "Set Your Work Schedule",
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
                  child: RegisterWorkScheduleForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterWorkScheduleForm extends StatefulWidget {
  const RegisterWorkScheduleForm({super.key});

  @override
  _RegisterWorkScheduleFormState createState() =>
      _RegisterWorkScheduleFormState();
}

class _RegisterWorkScheduleFormState extends State<RegisterWorkScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];

  // Get current user from Firebase Auth
  User? currentUser = FirebaseAuth.instance.currentUser;

  // Add new variables for schedule
  String? startDay = 'Monday';
  String? endDay = 'Friday';
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 17, minute: 0);
  TimeOfDay restStartTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay restEndTime = const TimeOfDay(hour: 13, minute: 0);

  // List of days for dropdown
  final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // Helper method to show time picker
  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay) onSelect) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() => onSelect(picked));
    }
  }

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
          // Working Days Section
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
                  'Working Days',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: startDay,
                        decoration:
                            const InputDecoration(labelText: 'Start Day'),
                        items: weekDays.map((String day) {
                          return DropdownMenuItem(value: day, child: Text(day));
                        }).toList(),
                        onChanged: (value) => setState(() => startDay = value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: endDay,
                        decoration: const InputDecoration(labelText: 'End Day'),
                        items: weekDays.map((String day) {
                          return DropdownMenuItem(value: day, child: Text(day));
                        }).toList(),
                        onChanged: (value) => setState(() => endDay = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Working Hours Section
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
                  'Working Hours',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectTime(
                            context, startTime, (time) => startTime = time),
                        child: Text('Start Time: ${startTime.format(context)}'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectTime(
                            context, endTime, (time) => endTime = time),
                        child: Text('End Time: ${endTime.format(context)}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Rest Time Section
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
                  'Rest Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectTime(context, restStartTime,
                            (time) => restStartTime = time),
                        child: Text(
                            'Start Time: ${restStartTime.format(context)}'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectTime(
                            context, restEndTime, (time) => restEndTime = time),
                        child: Text('End Time: ${restEndTime.format(context)}'),
                      ),
                    ),
                  ],
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

                //Navigator.pushNamed(context, LoginSuccessScreen.routeName);
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
      await FirebaseFirestore.instance.collection('stores').doc(uid).update({
        'workSchedule': {
          'startDay': startDay,
          'endDay': endDay,
          'startTime': '${startTime.hour}:${startTime.minute}',
          'endTime': '${endTime.hour}:${endTime.minute}',
          'restStartTime': '${restStartTime.hour}:${restStartTime.minute}',
          'restEndTime': '${restEndTime.hour}:${restEndTime.minute}',
        },
      });

      if (mounted) {
        Navigator.pushNamed(context, RegisterBusinessGallery.routeName);
      }
    } catch (e) {
      print("Error saving Store Information: $e");
      addError(error: "Error saving Store Information. Please try again.");
    }
  }
}
