import 'package:flutter/material.dart';
import 'package:linktree/provider/follow_provider.dart';
import 'package:linktree/provider/link_provider.dart';
import 'package:linktree/views/auth/login_view.dart';
import 'package:linktree/views/links/add_Link.dart';
import 'package:linktree/views/follow_pages/followes_list_page.dart';
import 'package:linktree/views/follow_pages/following_list_page.dart';
import 'package:linktree/views/home/home_view.dart';
import 'package:linktree/views/home/main_app_view.dart';
import 'package:linktree/views/profile/profile_view.dart';
import 'package:linktree/views/recive/receive_view.dart';
import 'package:linktree/views/auth/register_view.dart';
import 'package:linktree/views/search/search_view.dart';
import 'package:linktree/views/widgets/loading_view.dart';
import 'package:provider/provider.dart';

import '../../core/utilies/constants.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LinkProvider()),
        ChangeNotifierProvider(create: (_) => FollowProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Betweener',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: kPrimaryColor,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          scaffoldBackgroundColor: kScaffoldColor,
        ),
        home: const LoadingScreen(),
        routes: _generateRoutes(),
      ),
    );
  }

  Map<String, WidgetBuilder> _generateRoutes() {
    return {
      LoadingScreen.id: (context) => const LoadingScreen(),
      LoginView.id: (context) => const LoginView(),
      RegisterView.id: (context) => const RegisterView(),
      SearchPage.id: (context) => const SearchPage(),
      HomeView.id: (context) => const HomeView(),
      MainAppView.id: (context) => const MainAppView(),
      ProfileView.id: (context) => const ProfileView(),
      AddLink.id: (context) => const AddLink(),
      ReceiveView.id: (context) => const ReceiveView(),
      FollowersList.id: (context) => const FollowersList(),
      FollowingList.id: (context) => const FollowingList(),
    };
  }
}
