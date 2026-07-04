import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_food_mobile/core/constants/app_colors.dart';
import 'package:order_food_mobile/core/constants/route_path_constant.dart';
import 'package:order_food_mobile/models/user.dart';
import 'package:order_food_mobile/services/auth_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  User? user;

  bool isProfileLoading = true; 
  bool isLoggingOut = false;    
  String? errorMessage;

  Future<void> dataProfile() async {
    setState(() {
      isProfileLoading = true;
      errorMessage = null;
    });

    try {
      final data = await authService.getProfile();
      if (!mounted) return;
      setState(() {
        user = data;
        isProfileLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isProfileLoading = false;
      });
    }
  }

  Future<void> handleLogout() async {
    setState(() {
      isLoggingOut = true;
      errorMessage = null;
    });

    final result = await authService.logout();

    if (!mounted) return;

    setState(() {
      isLoggingOut = false;
    });

    if (result == 'success') {
      context.replace(RoutePathConstant.login);
    } else {
      setState(() {
        errorMessage = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dataProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isProfileLoading
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
            : Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const CircleAvatar(
                          radius: 100,
                          child: Center(
                            child: Icon(Icons.person, size: 100),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Halo Selamat Datang, ",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              user?.name ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_pin),
                            const SizedBox(width: 5),
                            Text(
                              user?.address ?? "-",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Role : ",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              user?.role ?? "-",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: FilledButton(
                            onPressed: isLoggingOut ? null : handleLogout,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(double.infinity, 45),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isLoggingOut)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else ...[
                                  const Icon(Icons.logout),
                                  const SizedBox(width: 10),
                                  const Text("LOGOUT"),
                                ],
                              ],
                            ),
                          ),
                        ),
                        if (errorMessage != null)
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}