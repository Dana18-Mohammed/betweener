import 'package:http/http.dart' as http;

import 'package:linktree/models/user.dart';

import '../core/utilies/constants.dart';

Future<User> login(Map<String, String> body) async {
  final response = await http.post(Uri.parse(loginUrl), body: body);
  if (response.statusCode == 200) {
    return userFromJson(response.body);
  } else {
    throw Exception('Failed to login');
  }
}

Future<User> register(Map<String, String> body) async {
  final response = await http.post(Uri.parse(regUrl), body: body);
  if (response.statusCode == 200) {
    return userFromJson(response.body);
  } else if (response.statusCode == 201) {
    throw Exception('user created ');
  } else {
    throw Exception('Failed to Register');
  }
}
