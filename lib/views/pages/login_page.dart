import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_food_mobile/core/constants/app_colors.dart';
import 'package:order_food_mobile/core/constants/route_path_constant.dart';
import 'package:order_food_mobile/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isLogging = false;
  String? errorMessage;

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
      isLogging = true;
      errorMessage = null;
    });

    final result = await authService.login(
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
      isLogging = false;
    });

    if (result == 'success') {
      context.replace(RoutePathConstant.home);
    } else {
      setState(() {
        errorMessage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 2,
                  child: Image.asset("assets/images/logo_black.png"),
                ),
                SizedBox(height: 20,),
                Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkColor,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "example@gmail.com",
                    prefixIcon: Icon(Icons.email)
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key)
                  ),
                ),
                SizedBox(height: 20),
        
                if (errorMessage != null)
                  SizedBox(
                    child: Column(
                      children: [
                        Text(
                          errorMessage!,
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
        
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: AppColors.darkColor,
                  ),
                  onPressed: isLogging ? null : handleLogin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLogging)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else ...[
                        const Icon(Icons.login),
                        const SizedBox(width: 10),
                        const Text("LOGIN"),
                      ],
                    ],
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
