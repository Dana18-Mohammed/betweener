import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

Future<User?> getUser() async {
  // User? user;
  getLocalUser().then((value) {
    // user = value;
  }).catchError((err) {});
  return null;
}

Future<User> getLocalUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('user')) {
    return userFromJson(prefs.getString('user')!);
  }
  return Future.error('not found');
}
