import 'package:flutter/material.dart';
import 'package:linktree/views/login_view.dart';
import 'package:linktree/views/main_app_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  static String id = '/loadingView';

  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void checkLogin() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('user') && mounted) {
      Navigator.pushNamed(context, MainAppView.id);
    } else {
      Navigator.pushNamed(context, LoginView.id);
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
