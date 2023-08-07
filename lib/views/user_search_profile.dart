import 'package:flutter/material.dart';
import 'package:linktree/constants.dart';
import 'package:linktree/models/user.dart';

import '../controller/follower_controller.dart';
import '../models/followee.dart';

class Usersearch extends StatefulWidget {
  final UserClass user;

  static String id = '/usersearch';

  const Usersearch({Key? key, required this.user}) : super(key: key);
  @override
  State<Usersearch> createState() => _UsersearchState();
}

class _UsersearchState extends State<Usersearch> {
  bool isFollowed = false;
  late Followee followeeData;
  late List<Follow> followingUsers;

  bool isLoading = true;
  void submit(int userId) async {
    final body = {"followee_id": userId};
    Followee followes = await getFolloweeData();
    followingUsers = followes.following!;
    for (var following in followingUsers) {
      if (following.id == userId) {
        isFollowed = true;
      } else {
        isFollowed = false;
        addFollow(body).then((value) {
          setState(() {
            followeeData.following!.add(Follow(
              id: userId,
              name: widget.user.name!,
              email: widget.user.email!,
            ));
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Profile',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: kPrimaryColor),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 180,
                child: Card(
                  color: kPrimaryColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/imgs/img.png'),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.user.name}'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.user.email}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  submit(widget.user.id!);
                                  isFollowed = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kSecondaryColor,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                (isFollowed ? 'Following' : 'Follow'),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (widget.user.links != null && widget.user.links!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.user.links!.length,
                  itemBuilder: (context, index) {
                    final link = widget.user.links![index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? kLightDangerColor
                              : kLightPrimaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              (link.title ?? '').toUpperCase(),
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
                              link.title ?? '',
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
                    );
                  },
                ),
              )
            else
              const Center(
                child: Text('No links found'),
              ),
          ],
        ));
  }
}
