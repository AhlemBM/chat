import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../components/store_card.dart';
import '../../../../services/stores_provider.dart';
import '../stores_screen.dart';
import '../../details/details_screen.dart';
import 'section_title.dart';

class ExclusiveDiscounts extends StatelessWidget {
  const ExclusiveDiscounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoresProvider>(
      builder: (context, storesProvider, child) {
        if (storesProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (storesProvider.error != null) {
          return Center(child: Text('Error: ${storesProvider.error}'));
        }

        final stores = storesProvider.stores;
        if (stores.isEmpty) {
          return Center(child: Text('No stores available'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                title: "Exclusive Deals!",
                press: () {
                  Navigator.pushNamed(context, StoresScreen.routeName);
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    stores.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: StoreCard(
                          store: stores[index],
                          onPress: () => Navigator.pushNamed(
                            context,
                            DetailsScreen.routeName,
                            arguments: StoreDetailsArguments(
                              store: stores[index],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
