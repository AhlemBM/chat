import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../models/Store.dart';
import '../constants.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({
    super.key,
    this.width = 200,
    this.aspectRetio = 1.02,
    required this.store,
    required this.onPress,
  });

  final double width, aspectRetio;
  final Store store;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    store.gallery.isNotEmpty
                        ? store.gallery.first
                        : 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              store.businessName,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "From ${store.services.map((s) => s['price']).reduce((a, b) => a < b ? a : b)} TND",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: // store.isFavourite? kPrimaryColor.withOpacity(0.15):
                          kSecondaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Heart Icon_2.svg",
                      colorFilter: ColorFilter.mode(
                          //store.isFavourite ? const Color(0xFFFF4848) : const
                          Color(0xFFDBDEE4),
                          BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
