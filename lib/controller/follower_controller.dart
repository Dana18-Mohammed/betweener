import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/followee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

Future<Followee> getFolloweeData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.get(Uri.parse(followeUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    print(response.body);
    return followeeFromJson(response.body);
  } else {
    throw Exception('Failed to fetch followee data');
  }
}

Future<List<Followee>> getListFolloweeData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.get(Uri.parse(followeUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);

    List<Followee> followees =
        jsonData.map((data) => Followee.fromJson(data)).toList();

    return followees;
  } else {
    throw Exception('Failed to fetch followee data');
  }
}

Future<Followee> addFollow(Map<String, int> body) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);

  Map<String, String> requestBody =
      body.map((key, value) => MapEntry(key, value.toString()));

  final response = await http.post(Uri.parse(followeUrl),
      body: requestBody, headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    return followeeFromJson(response.body);
  } else {
    throw Exception('something went wrong in add follow');
  }
}
