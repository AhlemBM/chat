import 'package:flutter/material.dart';

import '../../../../constants.dart';


class ProfileInfo extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;
  final String location; // Add location parameter
  final bool isBusiness; // Add isBusiness parameter
  final bool isStaff;    // Add isStaff parameter

  const ProfileInfo({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
    required this.location,
    required this.isBusiness,
    required this.isStaff,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.label, color: kPrimaryColor),
              const SizedBox(width: 10),
              ..._buildRoleTags(), // Display role tags
            ],
          ),
          const SizedBox(height: 10),
          _buildProfileRow(Icons.person, "$firstName $lastName"),
          const SizedBox(height: 10),
          _buildProfileRow(Icons.mail_outline, email),
          const SizedBox(height: 10),
          _buildProfileRow(Icons.phone, mobileNumber),
          const SizedBox(height: 10),
          _buildProfileRow(Icons.location_on_outlined, location),
        ],
      ),
    );
  }

  List<Widget> _buildRoleTags() {
    List<Widget> tags = [];

    // Add default "client" tag
    tags.add(_buildTag("Client", Colors.blue)); // Example color for client

    // Add business owner tag if applicable
    if (isBusiness) {
      tags.add(_buildTag("Business Owner", kSecondaryColor)); // Example color for business Owner
    }

    // Add staff tag if applicable
    if (isStaff) {
      tags.add(_buildTag("Staff", kSuccessColor)); // Example color for Staff
    }

    return tags;
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Lighten the background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color), // Set text color to match the tag color
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor),
          const SizedBox(width: 30),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
