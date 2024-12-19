// notifications_screen.dart
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  static String routeName = "/notifications";
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
            children: [
              Text(
                "notifications",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              )
            ]));
  }
}
