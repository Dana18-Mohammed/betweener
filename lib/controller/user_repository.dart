import 'package:shared_preferences/shared_preferences.dart';

import '../core/sharedPref/my_shared_prefs.dart';
import '../models/user.dart';

class UserRepository {
  Future<User?> getUser() async {
    // User? user;
    getLocalUser().then((value) {
      // user = value;
    }).catchError((err) {});
    return null;
  }

  Future<User> getLocalUser() async {
    SharedPreferenceController().getValueFor('user');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      return userFromJson(prefs.getString('user')!);
    }
    return Future.error('not found');
  }
}
