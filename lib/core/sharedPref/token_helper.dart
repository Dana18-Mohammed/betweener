import 'package:linktree/core/sharedPref/my_shared_prefs.dart';

Future<String> getToken() async {
  print('in token');
  print(await SharedPreferenceController().getData('token'));
  return await SharedPreferenceController().getData('token');
}
