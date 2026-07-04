import 'package:flutter/material.dart';
import 'package:order_food_mobile/core/configs/app_config.dart';
import 'package:order_food_mobile/core/constants/app_colors.dart';
import 'package:order_food_mobile/core/utilities/format_currency.dart';

class ContentCardWidget extends StatelessWidget {
  final String? name;
  final int? price;
  final String? image;

  const ContentCardWidget({
    super.key,
    this.name,
    this.price,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: AppColors.whiteGrayColor,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(aspectRatio: 1.4, child: Image.network("${AppConfig.storageUrl}${image}", fit: BoxFit.cover,)),
                Text(
                  name ?? "-",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  FormatCurrency.toRupiah(price ?? 0),
                  style: TextStyle(fontSize: 15),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_add),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
