import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bank_dokumen/features/admin/pages/dashboard_page.dart';
import 'package:bank_dokumen/features/user/pages/dashboard_user_page.dart';
import 'package:bank_dokumen/features/auth/page/login_page.dart';
import 'package:bank_dokumen/features/user/pages/dashboard_user_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role') ?? '';

    Widget targetPage;
    if (isLoggedIn) {
      if (role == 'admin') {
        targetPage = const AdminDashboardScreen();
      } else if (role == 'user') {
        targetPage = const UserDashboardPage();
      } else {
        targetPage = const LoginPage();
      }
    } else {
      targetPage = const LoginPage();
    }

    await Future.delayed(const Duration(seconds: 2)); // Optional delay
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
