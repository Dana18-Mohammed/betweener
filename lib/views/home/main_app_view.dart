import 'package:flutter/material.dart';
import 'package:linktree/views/home/home_view.dart';
import 'package:linktree/views/profile/profile_view.dart';
import 'package:linktree/views/auth/register_view.dart';
import 'package:linktree/views/widgets/custom_floating_nav_bar.dart';

class MainAppView extends StatefulWidget {
  static String id = '/mainAppView';

  const MainAppView({super.key});

  @override
  State<MainAppView> createState() => _MainAppViewState();
}

class _MainAppViewState extends State<MainAppView> {
  int _currentIndex = 1;

  late List<Widget?> screensList = [
    // const ReceiveView(),
    const RegisterView(),
    const HomeView(),
    const ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screensList[_currentIndex],
      extendBody: true,
      bottomNavigationBar: CustomFloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
