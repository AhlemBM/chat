// client_bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glamify_app/constants.dart';

class BusinessBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BusinessBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, FontAwesomeIcons.house),
          _buildNavItem(1, FontAwesomeIcons.chartLine),
          _buildNavItem(2, FontAwesomeIcons.calendar),
          _buildNavItem(3, FontAwesomeIcons.bell),
          _buildNavItem(4, FontAwesomeIcons.users),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
          isSelected ? kPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: FaIcon(
          icon,
          size: 22,
          color: isSelected ? Colors.white : kTextMutedColor,
        ),
      ),
    );
  }
}
