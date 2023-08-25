import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../controller/follower_repository.dart';
import '../../core/utilies/constants.dart';
import '../../models/followee_response_model.dart';

class FollowingList extends StatefulWidget {
  static String id = '/FolloweringList';
  const FollowingList({Key? key}) : super(key: key);

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  late Future<List<Follow>?> followingUsers;

  @override
  void initState() {
    followingUsers = FolloweeRepository().getFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your Followers '),
      ),
      body: FutureBuilder(
        future: followingUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              child: SizedBox(
                height: 1000,
                child: ListView.builder(
                  padding: const EdgeInsets.all(4),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final name = snapshot.data?[index].name;
                    final email = snapshot.data?[index].email;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 350,
                              height: 80,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? kLightDangerColor
                                    : kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '$name'.toUpperCase(),
                                    style: TextStyle(
                                      color: index % 2 == 0
                                          ? kOnLightDangerColor
                                          : kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$email',
                                    style: TextStyle(
                                      color: index % 2 == 0
                                          ? kOnLightDangerColor
                                          : kPrimaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No Followers',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
