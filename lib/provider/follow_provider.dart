import 'package:flutter/foundation.dart';
import 'package:linktree/controller/follower_repository.dart';
import 'package:linktree/core/helpers/api_response.dart';

import '../controller/link_repository .dart';
import '../models/followee_response_model.dart';
import '../models/link_response_model.dart';

class FollowProvider extends ChangeNotifier {
  late FolloweeRepository _followeeRepository;
  late ApiResponse<dynamic>? _follow;
  FollowProvider() {
    _followeeRepository = FolloweeRepository();
    getListFolloweeData();
  }
  ApiResponse<dynamic>? get follow => _follow;

  getFolloweeData() async {
    _follow = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await _followeeRepository.getFolloweeData();
      print(response);
      _follow = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _follow = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  void getListFolloweeData() async {
    _follow = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await _followeeRepository.getListFolloweeData();
      print(response);
      _follow = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _follow = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  void addFollow(int followeeId) async {
    _follow = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response =
          await _followeeRepository.addFollow({"followee_id": followeeId});
      print(response);
      _follow = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _follow = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  getNumberFollowers() async {
    try {
      Future<Followee> followeeData = getFolloweeData();
      Followee followee = await followeeData;

      int? follower = followee.followersCount;
      notifyListeners();

      return follower;
    } catch (e) {
      throw Exception();
    }
  }

  getNumberFollowing() async {
    try {
      Future<Followee> followeeData = getFolloweeData();
      Followee followee = await followeeData;

      int? following = followee.followingCount;
      notifyListeners();

      return following;
    } catch (e) {
      throw Exception();
    }
  }
}
