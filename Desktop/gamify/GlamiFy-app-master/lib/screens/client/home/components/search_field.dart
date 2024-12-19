import 'package:flutter/material.dart';
import 'map_selection_page.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
          GestureDetector(
            onTap: () async {
              final selectedLocation = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapSelectionPage()),
              );

              if (selectedLocation != null) {
                print('Selected location: $selectedLocation');
              }
            },
            child: TextFormField(
              onChanged: (value) {},
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blue.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: searchOutlineInputBorder,
                focusedBorder: searchOutlineInputBorder,
                enabledBorder: searchOutlineInputBorder,
                hintText: "Where ?",
                prefixIcon: const Icon(Icons.location_on),
              ),
            ),
    ),
    );
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);
