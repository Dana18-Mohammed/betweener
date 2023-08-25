import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linktree/core/sharedPref/my_shared_prefs.dart';
import 'package:linktree/core/sharedPref/token_helper.dart';
import 'package:linktree/models/link_response_model.dart';
import '../core/helpers/api_base_helper.dart';
import '../core/utilies/constants.dart';

import 'package:linktree/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LinkRepository {
  Future<List<Link>?> fetchLinkList() async {
    final ApiBaseHelper helper = ApiBaseHelper();
    final token = await getToken();

    final response = await helper.get("/links", {
      'Authorization': 'Bearer $token',
    });
    print(response);
    return LinkResponseModel.fromJson(response).links;
  }

  Future<List<Link>?> addLink(Map<String, String> body) async {
    final ApiBaseHelper helper = ApiBaseHelper();
    final token = await getToken();

    final response =
        await helper.post('/links', body, {'Authorization': 'Bearer $token'});
    print(response);
    return LinkResponseModel.fromJson(response).links;
  }

  Future<List<Link>?> editLink(int id, Map<String, String> body) async {
    final ApiBaseHelper helper = ApiBaseHelper();
    final token = await getToken();

    final response =
        await helper.put("links/$id", body, {'Authorization': 'Bearer $token'});
    print(response);
    return LinkResponseModel.fromJson(response).links;
  }

  Future<List<Link>?> deleteLink(int id) async {
    final ApiBaseHelper helper = ApiBaseHelper();
    final token = await getToken();

    final response =
        await helper.delete("links/$id", {'Authorization': 'Bearer $token'});
    print(response);
    return LinkResponseModel.fromJson(response).links;
  }
}

// Future<Link> addLink(Map<String, String> body) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   User user = userFromJson(prefs.getString('user')!);
//   final response = await http.post(Uri.parse(linkUrl),
//       body: body, headers: {'Authorization': 'Bearer ${user.token}'});
//   if (response.statusCode == 200) {
//     return linksFromJson(response.body);
//   } else {
//     throw Exception('some thing error in add link');
//   }
// }
//
// Future<User> deleteLink(int id) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   User user = userFromJson(prefs.getString('user')!);
//
//   final deleteUrl = Uri.parse('$linkUrl/$id');
//
//   final response = await http
//       .delete(deleteUrl, headers: {'Authorization': 'Bearer ${user.token}'});
//   if (response.statusCode == 200) {
//     return userFromJson(response.body);
//   } else {
//     throw Exception('something went wrong while deleting the link');
//   }
// }
//
// Future<Link> editLink(int id, Map<String, String> body) async {
//   final SharedPreferences _prefs = await SharedPreferences.getInstance();
//   User user = userFromJson(_prefs.getString('user')!);
//
//   final updateUrl = Uri.parse('$linkUrl/$id');
//
//   final response = await http.put(updateUrl,
//       body: body, headers: {'Authorization': 'Bearer ${user.token}'});
//   if (response.statusCode == 200) {
//     return linksFromJson(response.body);
//   } else {
//     throw Exception('something went wrong while editing the link');
//   }
// }
