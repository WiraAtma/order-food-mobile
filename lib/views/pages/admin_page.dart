import 'package:flutter/material.dart';
import 'package:order_food_mobile/core/types/category_type.dart';
import 'package:order_food_mobile/models/menu.dart';
import 'package:order_food_mobile/services/menu_services.dart';
import 'package:order_food_mobile/views/widgets/admin_menu_card.dart';
import 'package:order_food_mobile/views/widgets/form_menu_widget.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  children: [
                    FilledButton(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => const FormMenuWidget(),
                        );

                        if (result == true) {
                          dataMenu();
                        }
                      },
                      child: Row(children: [Icon(Icons.add), Text("Add Menu")]),
                    ),
                  ],
                ),
                isMenuLoading
                    ? Center(
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
                    ? Center(
                        child: Column(
                          children: [
                            Icon(Icons.inbox_outlined),
                            SizedBox(height: 12),
                            Text(
                              "Tidak Ada Data",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                      spacing: 20,
                        children: List.generate(menus.length, (index) {
                          final menu = menus[index];
                          return AdminMenuCard(
                            name: menu.name,
                            price: menu.price,
                            image: menu.image,
                            onUpdated: dataMenu,
                            id: menu.id,
                          );
                        }),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
