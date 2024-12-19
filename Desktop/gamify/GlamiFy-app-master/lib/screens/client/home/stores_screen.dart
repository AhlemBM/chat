import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../components/store_card.dart';
import '../../../services/stores_provider.dart';
import '../details/details_screen.dart';

class StoresScreen extends StatelessWidget {
  static String routeName = "/stores";

  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoresProvider>(builder: (context, storesProvider, child) {
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
      return Scaffold(
        appBar: AppBar(
          title: Text("Stores"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: stores.length,
            itemBuilder: (context, index) {
              return StoreCard(
                store: stores[index],
                onPress: () {
                  // Navigate to store details
                  Navigator.pushNamed(
                    context,
                    DetailsScreen.routeName,
                    arguments: StoreDetailsArguments(store: stores[index]),
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }
}
