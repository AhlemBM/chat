import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../models/User.dart';
import '../../../services/stores_provider.dart';
import '../../auth/sign_in/sign_in_screen.dart';
import 'components/change_password.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';
import 'components/profile_info.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _scrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

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
                FadeInDown(
                  duration: const Duration(milliseconds: 1000),
                  child: const ProfilePic(),
                ),
                const SizedBox(height: 10),
                Text(
                  "Hi, ${userModel.firstName}!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _scrollOffset < 100 ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ProfileInfo(
                            firstName: userModel.firstName,
                            lastName: userModel.lastName,
                            email: userModel.email,
                            mobileNumber: userModel.mobileNumber,
                            location: userModel.location,
                            isBusiness: userModel.isBusiness,
                            isStaff: userModel.isStaff,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Menu items
                        _buildProfileMenus(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenus() {
    return Column(
      children: [
        ProfileMenu(
          text: "Change Password",
          icon: Icons.lock_outline,
          press: () => Navigator.pushNamed(context, ChangePasswordScreen.routeName),
        ),
        ProfileMenu(
          text: "My Reservations",
          icon: Icons.receipt_long,
          press: () {},
        ),
        ProfileMenu(
          text: "FAQ",
          icon: Icons.help_outline,
          press: () {},
        ),
        ProfileMenu(
          text: "Log Out",
          icon: Icons.logout,
          press: _logOut,
        ),
      ],
    );
  }

  Future<void> _logOut() async {
    final confirmLogout = await _showConfirmationDialog(
      title: "Confirm Log Out",
      content: "Are you sure you want to log out?",
      confirmButtonText: "Confirm",
      confirmButtonColor: Colors.black,
    );

    if (confirmLogout == true) {
      try {
        Provider.of<UserModel>(context, listen: false).resetUserData();
        Provider.of<StoresProvider>(context, listen: false).refresh();
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        print("Error signing out: $e");
      }
    }
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String content,
    required String confirmButtonText,
    required Color confirmButtonColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmButtonText, style: TextStyle(color: confirmButtonColor)),
            ),
          ],
        );
      },
    );
  }
}
