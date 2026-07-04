import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_food_mobile/core/constants/app_colors.dart';
import 'package:order_food_mobile/core/constants/route_path_constant.dart';
import 'package:order_food_mobile/views/widgets/navbar_widget.dart';

class WidgetTree extends StatelessWidget {
  final Widget child;

  const WidgetTree({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("Flutter App", style: TextStyle(color: AppColors.whiteGrayColor),),
      ),
      body: child,
      bottomNavigationBar: NavbarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(RoutePathConstant.cart),
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.shopping_cart, color: AppColors.whiteGrayColor,),
      ),
    );
  }
}
