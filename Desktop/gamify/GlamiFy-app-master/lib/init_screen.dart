import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glamify_app/constants.dart';
import 'package:glamify_app/screens/Client/home/home_screen.dart';
import 'package:glamify_app/screens/Client/notifications/notifications.dart';
import 'package:glamify_app/screens/Client/profile/profile_screen.dart';
import 'package:glamify_app/screens/business/home/home_screen2.dart';
import 'package:glamify_app/screens/business/register_business/register_business_screen.dart';
import 'package:glamify_app/screens/client/client_bottom_navigation_bar.dart';
import 'package:glamify_app/screens/business/business_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../../models/User.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static const String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen>
    with SingleTickerProviderStateMixin {
  int currentSelectedIndex = 0;
  bool isBusinessView = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    Provider.of<UserModel>(context, listen: false).loadUserProfile();

    // Initialize the animation controller
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  List<Widget> get pages {
    if (isBusinessView) {
      return [
        const BusinessHomeScreen(), // Home screen for business
        Center(child: Text("Business Analytics")), //
        Center(child: Text("Business Schedule")),
        NotificationsScreen(),
        Center(child: Text("Business Teams")),
      ];
    } else {
      return [
        const HomeScreen(), // Home screen for clients
        Center(child: Text("Schedule")),
        Center(child: Text("Schedule")),
        NotificationsScreen(),
        const ProfileScreen(), // Profile screen for clients
      ];
    }
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  void toggleView() async {
    // Start the rotation animation
    await _rotationController.forward(from: 0.0);

    setState(() {
      isBusinessView = !isBusinessView;
      currentSelectedIndex = 0;
    });

    final userModel = Provider.of<UserModel>(context, listen: false);
    if (isBusinessView && userModel.isBusiness && !userModel.hasStore) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const RegisterBusinessScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final canSwitchView = userModel.isBusiness || userModel.isStaff;

    return Scaffold(
      body: pages[currentSelectedIndex],
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          width: 100,
          height: 100,
          color: Colors.white,
        ),
        actions: [
          if (canSwitchView)
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_rotationController),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons
                      .rotate,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: toggleView,
              ),
            ),
        ],
      ),
      bottomNavigationBar: isBusinessView
          ? BusinessBottomNavigationBar(
              currentIndex: currentSelectedIndex,
              onTap: updateCurrentIndex,
            )
          : ClientBottomNavigationBar(
              currentIndex: currentSelectedIndex,
              onTap: updateCurrentIndex,
            ),
    );
  }
}
