import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_food_mobile/core/constants/app_colors.dart';
import 'package:order_food_mobile/core/constants/route_path_constant.dart';
import 'package:order_food_mobile/core/types/category_type.dart';
import 'package:order_food_mobile/models/menu.dart';
import 'package:order_food_mobile/services/menu_services.dart';
import 'package:order_food_mobile/views/widgets/content_card_widget.dart';
import 'package:order_food_mobile/views/widgets/home_category_widget.dart';
import 'package:order_food_mobile/views/widgets/home_header_widget.dart';
import 'package:order_food_mobile/views/widgets/home_searchbar_widget.dart';
import 'package:order_food_mobile/views/widgets/navbar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final menuService = MenuServices();
  List<Menu> menus = [];

  bool isMenuLoading = true;
  String? errorMessage;

  CategoryType selectedCategory = CategoryType.all;
  String searchQuery = "";

  Future<void> dataMenu() async {
    setState(() {
      isMenuLoading = true;
      errorMessage = null;
    });

    try {
      final params = <String, dynamic>{};
      final categoryValue = selectedCategory.apiValue;

      if (categoryValue != null) params['category'] = categoryValue;
      if (searchQuery.trim().isNotEmpty) params['q'] = searchQuery;

      final data = await menuService.getMenu(params.isEmpty ? null : params);
      if (!mounted) return;
      setState(() {
        menus = data;
        isMenuLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isMenuLoading = false;
      });
    }
  }

  void onCategorySelected(CategoryType category) {
    if (category == selectedCategory) return;
    setState(() {
      selectedCategory = category;
      dataMenu();
    });
  }

  void onSearchChanged(String value) {
    if (value == searchQuery) return;
    searchQuery = value;
    dataMenu();
  }

  @override
  void initState() {
    super.initState();
    dataMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeaderWidget(),
                SizedBox(height: 30),
                HomeSearchbarWidget(onChanged: onSearchChanged),
                HomeCategoryWidget(
                  selected: selectedCategory,
                  onSelected: onCategorySelected,
                ),
                SizedBox(height: 30),
                isMenuLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              "Memuat data...",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : menus.isEmpty
                    ? const Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Tidak ada data',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              mainAxisExtent: 225,
                              crossAxisSpacing: 12,
                            ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: menus.length,
                        itemBuilder: (context, index) {
                          final menu = menus[index];
                          return ContentCardWidget(
                            name: menu.name,
                            price: menu.price,
                            image: menu.image,
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(RoutePathConstant.cart),
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.shopping_cart, color: AppColors.whiteGrayColor),
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
