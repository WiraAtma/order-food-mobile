import 'package:go_router/go_router.dart';
import 'package:order_food_mobile/core/constants/route_path_constant.dart';
import 'package:order_food_mobile/views/pages/admin_page.dart';
import 'package:order_food_mobile/views/pages/bookmark_page.dart';
import 'package:order_food_mobile/views/pages/cart_page.dart';
import 'package:order_food_mobile/views/pages/home_page.dart';
import 'package:order_food_mobile/views/pages/login_page.dart';
import 'package:order_food_mobile/views/pages/profile_page.dart';
import 'package:order_food_mobile/views/widgets/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appRouter = GoRouter(
  initialLocation: RoutePathConstant.home,

  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final isLoginPage =
        state.matchedLocation == RoutePathConstant.login;

    if (token == null && !isLoginPage) {
      return RoutePathConstant.login;
    }

    if (token != null && isLoginPage) {
      return RoutePathConstant.home;
    }

    return null;
  },

  routes: [
    // pakai widget tree
    ShellRoute(
      builder: (context, state, child) {
        return WidgetTree(child: child);
      },
      routes: [
        GoRoute(
          path: RoutePathConstant.bookmark,
          builder: (context, state) => const BookmarkPage(),
        ),
        GoRoute(
          path: RoutePathConstant.profile,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: RoutePathConstant.admin,
          builder: (context, state) => const AdminPage(),
        ),
        GoRoute(
          path: RoutePathConstant.cart,
          builder: (context, state) => const CartPage(),
        ),
      ],
    ),

    // tidak pakai widget tree
    GoRoute(
      path: RoutePathConstant.home,
      builder: (context, state) => const HomePage(),
    ),

    GoRoute(
      path: RoutePathConstant.login,
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
