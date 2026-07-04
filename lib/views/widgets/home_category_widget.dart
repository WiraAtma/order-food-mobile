import 'package:flutter/material.dart';
import 'package:order_food_mobile/core/constants/app_colors.dart';
import 'package:order_food_mobile/core/types/category_type.dart';

class HomeCategoryWidget extends StatelessWidget {
  final CategoryType selected;
  final ValueChanged<CategoryType> onSelected;

  const HomeCategoryWidget({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        children: CategoryType.values.map((category) {
          final isSelected = category == selected;
          return FilledButton(
            onPressed: () => onSelected(category),
            style: FilledButton.styleFrom(
              backgroundColor: isSelected
                  ? AppColors.primaryColor
                  : AppColors.whiteGrayColor,
            ),
            child: Text(
              category.label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.darkSubtleColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}