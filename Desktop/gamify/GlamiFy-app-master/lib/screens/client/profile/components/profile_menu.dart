import 'package:flutter/material.dart';
import '../../../../constants.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon, // Change from String to IconData
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon; // Updated to IconData type
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(icon, color: kSecondaryColor),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: kPrimaryColor),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: kSecondaryColor,),
          ],
        ),
      ),
    );
  }
}
