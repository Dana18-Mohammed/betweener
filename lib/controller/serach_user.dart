import 'dart:convert';

import 'package:linktree/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;

Future<List<UserClass>> searchByUser(String searchName) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.post(Uri.parse(searchUrl), body: {
    'name': searchName,
  }, headers: {
    'Authorization': 'Bearer ${user.token}'
  });

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> userJsonList = jsonData['user'];

    return userJsonList
        .map((userJson) => UserClass.fromJson(userJson))
        .toList();
  } else {
    throw Exception('Failed to load users');
  }
}
