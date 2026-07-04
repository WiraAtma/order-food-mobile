import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_food_mobile/core/constants/route_path_constant.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    int selectedIndex = switch (location) {
      RoutePathConstant.home => 0,
      RoutePathConstant.cart => 1,
      RoutePathConstant.bookmark => 2,
      RoutePathConstant.admin => 3,
      RoutePathConstant.profile => 4,
      _ => 0,
    };

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go(RoutePathConstant.home);
            break;

          case 1:
            context.go(RoutePathConstant.cart);
            break;

          case 2:
            context.go(RoutePathConstant.bookmark);
            break;

          case 3:
            context.go(RoutePathConstant.admin);
            break;

          case 4:
            context.go(RoutePathConstant.profile);
            break;
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.shopping_cart), label: "Cart"),
        NavigationDestination(icon: Icon(Icons.bookmark), label: "Bookmark"),
        NavigationDestination(
          icon: Icon(Icons.admin_panel_settings),
          label: "Admin",
        ),
        NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
