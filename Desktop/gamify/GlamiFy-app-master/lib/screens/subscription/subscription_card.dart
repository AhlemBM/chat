import 'package:flutter/material.dart';
import 'package:glamify_app/constants.dart';
import '../../models/subscription_package.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPackage package;
  final bool isMonthly;
  final String? expandedCardTitle;
  final Function(String) onCardTap;

  const SubscriptionCard({
    super.key,
    required this.package,
    required this.isMonthly,
    required this.expandedCardTitle,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isExpanded = expandedCardTitle == package.title;
    bool isPremium = package.title.contains('Premium');

    return GestureDetector(
      onTap: () => onCardTap(package.title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isExpanded ? kSecondaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded
                ? kSecondaryColor.withOpacity(0.3)
                : kPrimaryColor.withOpacity(0.2),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        package.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isPremium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Most Popular',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: isExpanded ? kSecondaryColor : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${package.getPrice(isMonthly)}dt/${isMonthly ? 'month' : 'year'}',
              style: TextStyle(
                fontSize: 16,
                color: isExpanded ? kSecondaryColor : Colors.grey,
              ),
            ),
            if (!isMonthly)
              Text(
                'Save ${package.getYearlySavingsPercentage().toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (isExpanded) ...[
              const SizedBox(height: 16),
              Divider(color: Colors.grey.withOpacity(0.2)),
              const SizedBox(height: 16),
              ...package.features.map((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: kSecondaryColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your subscription logic here
                  },
                  child: Text(
                    package.isContactUs ? 'Contact Us' : 'Subscribe Now',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
