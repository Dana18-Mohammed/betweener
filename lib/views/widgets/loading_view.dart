import 'package:flutter/material.dart';
import 'package:linktree/views/home/main_app_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_view.dart';

class LoadingScreen extends StatefulWidget {
  static String id = '/loadingView';

  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('user') && mounted) {
      Navigator.pushReplacementNamed(context, MainAppView.id);
    } else {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
