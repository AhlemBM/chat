import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../models/subscription_package.dart';
import '../../constants.dart';
import 'subscription_card.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool isMonthly = true;
  double _scrollOffset = 0.0;
  String expandedCardTitle = "Premium";

  @override
  void initState() {
    super.initState();
  }

  List<SubscriptionPackage> get currentPackages =>
      SubscriptionPackage.getPackages(isMonthly);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: _scrollOffset < 100 ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
              children: [
                const SizedBox(height: 100),
                FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: Image.asset(
                    "assets/images/logo_welcome.png",
                    height: 100,
                    color: _scrollOffset < 100 ? Colors.white : Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          "Choose Your Plan",
                          style: TextStyle(
                            color: _scrollOffset < 100
                                ? Colors.white
                                : Colors.black,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: Text(
                          "Select the perfect subscription for you",
                          style: TextStyle(
                            color: _scrollOffset < 100
                                ? Colors.white
                                : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildToggleButton('Monthly', isMonthly),
                              _buildToggleButton('Yearly', !isMonthly),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...currentPackages.map((package) => Column(
                              children: [
                                SubscriptionCard(
                                  package: package,
                                  isMonthly: isMonthly,
                                  expandedCardTitle: expandedCardTitle,
                                  onCardTap: (title) {
                                    setState(() {
                                      expandedCardTitle = title;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            )),
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

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMonthly = text == 'Monthly';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
