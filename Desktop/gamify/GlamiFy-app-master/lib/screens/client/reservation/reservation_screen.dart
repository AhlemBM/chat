import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for the logged-in user
import 'package:table_calendar/table_calendar.dart'; // Import TableCalendar package

class ReservationScreen extends StatefulWidget {
  static String routeName = "/reservation";

  const ReservationScreen({super.key});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  // Controller for the comment field
  final TextEditingController _commentController = TextEditingController();

  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String _selectedTime = "";

  User? currentUser = FirebaseAuth.instance.currentUser; // Logged-in user

  @override
  Widget build(BuildContext context) {
    // Retrieve passed arguments (service and store name)
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final service = arguments['service'];
    final storeName = arguments['storeName'];

    // Define the reservation button color
    final Color buttonColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation - $storeName"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with "Your service order" on the left and "Add more +" on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your service order',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    // Naviguer vers la page DetailsScreen (sans arguments spécifiques)
                    Navigator.pushNamed(context, '/details');
                  },
                  child: Row(
                    children: [
                      Text(
                        'Add more ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              buttonColor, // Text color according to the theme
                        ),
                      ),
                      Icon(
                        Icons.add_circle_outline,
                        color: buttonColor, // Icon color
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Display service details
            Text(
              'Service: ${service['name']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${service['price']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Duration: ${service['duration']} min',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Add calendar with weekly view
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime(2020),
              lastDay: DateTime(2100),
              calendarFormat: CalendarFormat.week, // Weekly view
              selectedDayPredicate: (day) {
                // Returns true if the day is the selected day
                return isSameDay(day, _selectedDate);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  // Formater la date au format 'yyyy-MM-dd'
                  _selectedDate = DateTime(
                      selectedDay.year, selectedDay.month, selectedDay.day);
                });
              },
            ),

            const SizedBox(height: 20),

            // Display available times in rectangular format
            Text(
              'Available times:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // List of times with rectangular frames
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Horizontal scrolling
              child: Row(
                children: List.generate(10, (index) {
                  int hour = 9 + index;
                  if (hour == 12) hour++; // Skip 12h-13h for lunch break

                  String startTime = (hour < 10 ? '0' : '') + '$hour:00';
                  String endTime =
                      (hour + 1 < 10 ? '0' : '') + '${hour + 1}:00';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTime = '$startTime-$endTime';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTime == '$startTime-$endTime'
                              ? buttonColor.withOpacity(0.2)
                              : Colors
                                  .transparent, // Change color if the time is selected
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                          border: Border.all(
                            color: buttonColor,
                            width: 2,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        child: Center(
                          child: Text(
                            '$startTime-$endTime',
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Field for adding a comment
            Text(
              'Add a comment:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Your comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: buttonColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.transparent, // Transparent background
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              maxLines: 4, // Allow multiple lines for comments
            ),

            const SizedBox(height: 20),

            // Reservation button with the same color
            ElevatedButton(
              onPressed: () {
                // Check if the user is authenticated
                User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "You need to be logged in to make a reservation.")),
                  );
                  return; // Do not proceed if the user is not authenticated
                }

                // Create reservation data
                final reservationData = {
                  'agenda': _selectedDate, // Date and time of the reservation
                  'time': _selectedTime, // Time of the reservation

                  'service': service, // Service details
                  'storeName': storeName, // Store name
                  // 'cost': service['price'], // Total cost
                  'commentaire': _commentController.text, // Comment,
                  // 'image': service['image'], // Associated image
                  'userId': currentUser.uid, // Logged-in user's ID
                };

                // Add the reservation to Firestore
                FirebaseFirestore.instance
                    .collection('reservations')
                    .add(reservationData)
                    .then((value) {
                  print('Reservation added successfully');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Reservation confirmed!")),
                  );
                }).catchError((error) {
                  print("Error adding reservation: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error with the reservation")),
                  );
                });
              },
              child: Text('Reserve this service'),
            ),
          ],
        ),
      ),
    );
  }
}
