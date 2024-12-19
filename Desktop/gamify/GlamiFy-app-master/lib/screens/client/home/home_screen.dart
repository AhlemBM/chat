import 'package:flutter/material.dart';
import 'package:glamify_app/screens/client/home/components/section_categories.dart';
import 'components/exclusive_discounts.dart';
import 'components/search_field.dart';
import 'components/special_offers.dart';
import 'components/section_stores.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SearchField(),
              const SizedBox(height: 20),
              SpecialOffers(),
              const SizedBox(height: 20),
              SectionCategories(),
              ExclusiveDiscounts(),
              Stores(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}
