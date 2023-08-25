import 'package:shared_preferences/shared_preferences.dart';

import '../core/helpers/api_base_helper.dart';
import '../core/sharedPref/token_helper.dart';
import '../core/utilies/constants.dart';
import '../models/followee_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class FolloweeRepository {
  Future<Followee> getFolloweeData() async {
    final ApiBaseHelper helper = ApiBaseHelper();
    final token = await getToken();

    final response =
        await helper.get("/follow", {'Authorization': 'Bearer $token'});

    return followeeFromJson(response.body);
  }

  Future<List<Followee>> getListFolloweeData() async {
    final ApiBaseHelper helper = ApiBaseHelper();
    final token = await getToken();

    final response =
        await helper.get("/follow", {'Authorization': 'Bearer $token'});

    List<dynamic> jsonData = json.decode(response.body);

    List<Followee> followees =
        jsonData.map((data) => Followee.fromJson(data)).toList();

    return followees;
  }

  Future<Followee> addFollow(Map<String, int> body) async {
    final ApiBaseHelper helper = ApiBaseHelper();
    final token = await getToken();

    Map<String, String> requestBody =
        body.map((key, value) => MapEntry(key, value.toString()));

    final response = await helper.post("/follow", requestBody, {
      'Authorization': 'Bearer'
          ' $token'
    });

    return followeeFromJson(response.body);
  }

  Future<List<Follow>?> getFollowers() async {
    Followee followes = await getFolloweeData();
    return followes.followers;
  }

  Future<List<Follow>?> getFollowing() async {
    Followee followes = await getFolloweeData();
    return followes.followers;
  }
}
