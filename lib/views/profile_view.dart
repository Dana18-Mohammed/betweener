import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:linktree/constants.dart';
import 'package:linktree/controller/link_controller.dart';
import 'package:linktree/models/Links.dart';
import 'package:linktree/models/user.dart';
import 'package:linktree/views/edit_user_profile.dart';
import 'package:linktree/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/follower_controller.dart';
import '../models/followee.dart';
import 'add_Link.dart';

class ProfileView extends StatefulWidget {
  static String id = '/profileView';

  const ProfileView({Key? key}) : super(key: key);
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<User> user;
  late Future<List<Links>> links;
  late List<Links> linksData;
  int? follower;
  int? following;

  late Future<Followee> followeeData;

  Future<User> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      return userFromJson(prefs.getString('user')!);
    }
    return Future.error('error');
  }

  Future<void> delete(int linkId) async {
    try {
      setState(() {
        linksData.removeWhere((link) => link.id == linkId);
      });
      await deleteLink(linkId);
    } catch (e) {
      print('Error deleting link: $e');
    }
  }

  Future<List<Links>> getUserLinks() async {
    try {
      return getLinks(context);
    } catch (e) {
      print('Error fetching links: $e');
      return [];
    }
  }

  void _showEditPage(Links link) async {
    print('in edit');
    final editedLink = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLink(linkData: link, linksData: linksData),
      ),
    );

    if (editedLink != null && editedLink is Links) {
      final index = linksData.indexWhere((link) => link.id == editedLink.id);
      if (index != -1) {
        setState(() {
          linksData[index] = editedLink;
        });
      }
    }
  }

  Future<void> getNumberFollowers() async {
    try {
      Followee followee = await followeeData;
      follower = followee.followersCount;
      following = followee.followingCount;
    } catch (e) {
      throw Exception();
    }
  }

  void _logout() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
      Navigator.pushReplacementNamed(context, LoginView.id);
    });
  }

  @override
  void initState() {
    user = getUserData();
    followeeData = getFolloweeData();

    linksData = [];
    getNumberFollowers();
    getLinks(context).then((links) {
      setState(() {
        linksData = links;
      });
    });
    super.initState();
  }

  Future<void> _navigateToAddLinkPage() async {
    final editedLink = await Navigator.pushNamed(
      context,
      AddLink.id,
      arguments: linksData,
    );
    if (editedLink != null && editedLink is Links) {
      setState(() {
        if (!linksData.contains(editedLink)) {
          linksData.add(editedLink);
        }
      });
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
            actions: [
              IconButton(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
              ),
            ]),
        body: Stack(
          children: [
            Column(
              children: [
                FutureBuilder(
                  future: user,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage('assets/imgs/img.png'),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${snapshot.data?.user?.name}'
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          IconButton(
                                              padding: const EdgeInsets.only(
                                                  left: 140),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditUserProfile(
                                                            user: user),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 60),
                                        child: Text(
                                          '${snapshot.data?.user?.email}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kSecondaryColor,
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: follower == null
                                                ? const CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                  ) // Show loading indicator
                                                : Text(
                                                    'Follower ${follower ?? 0}'),
                                          ),
                                          const SizedBox(width: 16),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kSecondaryColor,
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: follower == null
                                                ? const CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                  ) // Show loading indicator
                                                : Text(
                                                    'Following ${following ?? 0}'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return const Text('loading data');
                  },
                ),
                Expanded(
                  child: FutureBuilder<List<Links>>(
                    future: Future.value(linksData),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        return SingleChildScrollView(
                          child: SizedBox(
                            height: 350,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(4),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final linkTitle = snapshot.data?[index].title;
                                final link = snapshot.data?[index].link;
                                final linkIdToDelete = linksData[index].id;
                                return Slidable(
                                  endActionPane: ActionPane(
                                    extentRatio: 0.6,
                                    dismissible: DismissiblePane(
                                      onDismissed: () {},
                                    ),
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          setState(() {
                                            _showEditPage(
                                                snapshot.data![index]);
                                          });
                                        },
                                        backgroundColor: kSecondaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                        padding: const EdgeInsets.all(32),
                                        icon: Icons.edit,
                                        foregroundColor: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          if (linkIdToDelete != null) {
                                            setState(() {
                                              delete(linkIdToDelete);
                                            });
                                          }
                                        },
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete,
                                        borderRadius: BorderRadius.circular(20),
                                        padding: const EdgeInsets.all(8),
                                      )
                                    ],
                                  ),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 350,
                                            height: 80,
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: index % 2 == 0
                                                  ? kLightDangerColor
                                                  : kLightPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  '$linkTitle'.toUpperCase(),
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
                                                  '$link',
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
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.length,
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              right: 50,
              bottom: 100,
              child: FloatingActionButton(
                backgroundColor: kPrimaryColor,
                onPressed: () {
                  _navigateToAddLinkPage();
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ));
  }
}
