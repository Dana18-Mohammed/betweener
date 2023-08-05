import 'package:flutter/material.dart';
import 'package:linktree/views/add_Link.dart';
import 'package:linktree/views/home_view.dart';
import 'package:linktree/views/login_view.dart';
import 'package:linktree/views/main_app_view.dart';
import 'package:linktree/views/profile_view.dart';
import 'package:linktree/views/receive_view.dart';
import 'package:linktree/views/register_view.dart';
import 'package:linktree/views/search_view.dart';
import 'package:linktree/views/widgets/loading_view.dart';

import 'constants.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Betweener',
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: kPrimaryColor,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor),
          ),
          scaffoldBackgroundColor: kScaffoldColor),
      home: const LoadingScreen(),
      routes: {
        LoadingScreen.id: (context) => const LoadingScreen(),
        LoginView.id: (context) => const LoginView(),
        RegisterView.id: (context) => const RegisterView(),
        SearchPage.id: (context) => const SearchPage(),
        HomeView.id: (context) => const HomeView(),
        MainAppView.id: (context) => const MainAppView(),
        ProfileView.id: (context) => const ProfileView(),
        AddLink.id: (context) => const AddLink(),
        ReceiveView.id: (context) => const ReceiveView(),
      },
    );
  }
}
