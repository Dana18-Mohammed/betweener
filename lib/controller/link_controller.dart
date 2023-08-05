import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linktree/constants.dart';
import 'package:linktree/models/Links.dart';
import 'package:linktree/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Links>> getLinks(context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.get(Uri.parse(linkUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    // print(response.body);
    final data = jsonDecode(response.body)['links'] as List<dynamic>;
    return data.map((e) => Links.fromJson(e)).toList();
  }
  if (response.statusCode == 401) {
    // Navigator.pushReplacementNamed(context, LoginView.id);
  }
  return Future.error('error');
}

Future<Links> addLink(Map<String, String> body) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.post(Uri.parse(linkUrl),
      body: body, headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    return linksFromJson(response.body);
  } else {
    throw Exception('some thing error in add link');
  }
}

Future<User> deleteLink(int id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);

  final deleteUrl = Uri.parse('$linkUrl/$id');

  final response = await http
      .delete(deleteUrl, headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    return userFromJson(response.body);
  } else {
    throw Exception('something went wrong while deleting the link');
  }
}

Future<Links> editLink(int id, Map<String, String> body) async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  User user = userFromJson(_prefs.getString('user')!);

  final updateUrl = Uri.parse('$linkUrl/$id');

  final response = await http.put(updateUrl,
      body: body, headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    return linksFromJson(response.body);
  } else {
    throw Exception('something went wrong while editing the link');
  }
}
