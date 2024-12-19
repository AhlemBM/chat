import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final String type;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  static List<ServiceCategory> categories = [
    // Barber Categories
    ServiceCategory(
      id: 'haircut',
      name: 'Haircut',
      icon: FontAwesomeIcons.scissors,
      type: 'barber',
    ),
    ServiceCategory(
      id: 'beard',
      name: 'Beard Trim',
      icon: FontAwesomeIcons.userTie,
      type: 'barber',
    ),
    ServiceCategory(
      id: 'shave',
      name: 'Clean Shave',
      icon: FontAwesomeIcons.faceSmile,
      type: 'barber',
    ),

    // Beauty Categories
    ServiceCategory(
      id: 'makeup',
      name: 'Makeup',
      icon: FontAwesomeIcons.wandMagicSparkles,
      type: 'beauty',
    ),
    ServiceCategory(
      id: 'nails',
      name: 'Nails',
      icon: FontAwesomeIcons.handSparkles,
      type: 'beauty',
    ),
    ServiceCategory(
      id: 'hair_styling',
      name: 'Hair Styling',
      icon: FontAwesomeIcons.wandMagic,
      type: 'beauty',
    ),

    // Spa Categories
    ServiceCategory(
      id: 'massage',
      name: 'Massage',
      icon: FontAwesomeIcons.handHoldingHeart,
      type: 'spa',
    ),
    ServiceCategory(
      id: 'facial',
      name: 'Facial',
      icon: FontAwesomeIcons.spa,
      type: 'spa',
    ),
  ];
}
