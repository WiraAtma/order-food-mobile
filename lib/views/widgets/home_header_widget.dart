import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_food_mobile/core/constants/route_path_constant.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset("assets/images/logo_black.png"),
            ),
            InkWell(
              onTap: () => context.go(RoutePathConstant.profile),
              child: CircleAvatar(radius: 30, child: Text("IK")),
            ),
          ],
        ),
        Text("Order your favorite food!", style: TextStyle(height: -2)),
      ],
    );
  }
}
