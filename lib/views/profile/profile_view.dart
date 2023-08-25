import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:linktree/core/sharedPref/my_shared_prefs.dart';
import 'package:linktree/core/sharedPref/token_helper.dart';
import 'package:linktree/models/followee_response_model.dart';
import 'package:linktree/models/link_response_model.dart';
import 'package:linktree/provider/follow_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/follower_repository.dart';
import '../../core/helpers/api_response.dart';
import '../../core/utilies/constants.dart';
// import '../../models/followee_response_model.dart';
import '../../models/user.dart';
import '../../provider/link_provider.dart';
import '../auth/login_view.dart';
import '../follow_pages/followes_list_page.dart';
import '../follow_pages/following_list_page.dart';
import '../links/add_Link.dart';
import 'edit_user_profile.dart';

class ProfileView extends StatefulWidget {
  static String id = '/profileView';
  const ProfileView({Key? key}) : super(key: key);
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<User> user;
  late Future<List<Link>> links;
  late List<Link> linksData;
  LinkProvider linkProvider = LinkProvider();
  // int? follower;
  // int? following;

  Future<User> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      return userFromJson(prefs.getString('user')!);
    }
    return Future.error('error');
  }

  void _showEditPage(Link link) async {
    final editedLink = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLink(linkData: link),
      ),
    );

    if (editedLink != null && editedLink is Link) {
      final index = linksData.indexWhere((link) => link.id == editedLink.id);
      if (index != -1) {
        setState(() {
          linksData[index] = editedLink;
        });
      }
    }
  }

  @override
  void initState() {
    user = getUserData();

    linksData = [];

    super.initState();
  }

  Future<void> _navigateToAddLinkPage() async {
    final editedLink = await Navigator.pushNamed(
      context,
      AddLink.id,
      arguments: linksData,
    );
    if (editedLink != null && editedLink is Link) {
      setState(() {
        if (!linksData.contains(editedLink)) {
          linksData.add(editedLink);
        }
      });
      setState(() {});
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
                onPressed: () {
                  SharedPreferenceController().logout(context);
                },
                icon: const Icon(Icons.logout),
              ),
            ]),
        body: Stack(
          children: [
            Column(
              children: [
                // FutureBuilder(
                //   future: user,
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       return Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: SizedBox(
                //           height: 180,
                //           child: Card(
                //             color: kPrimaryColor,
                //             elevation: 2,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(16),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.symmetric(
                //                   vertical: 16, horizontal: 4),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   const CircleAvatar(
                //                     radius: 50,
                //                     backgroundImage:
                //                         AssetImage('assets/imgs/img.png'),
                //                   ),
                //                   const SizedBox(width: 20),
                //                   Column(
                //                     children: [
                //                       Row(
                //                         children: [
                //                           Text(
                //                             '${snapshot.data?.user?.name}'
                //                                 .toUpperCase(),
                //                             style: const TextStyle(
                //                                 fontSize: 18,
                //                                 fontWeight: FontWeight.bold,
                //                                 color: Colors.white),
                //                           ),
                //                           IconButton(
                //                               padding: const EdgeInsets.only(
                //                                   left: 140),
                //                               onPressed: () {
                //                                 Navigator.push(
                //                                   context,
                //                                   MaterialPageRoute(
                //                                     builder: (context) =>
                //                                         EditUserProfile(
                //                                             user: user),
                //                                   ),
                //                                 );
                //                               },
                //                               icon: const Icon(
                //                                 Icons.edit,
                //                                 color: Colors.white,
                //                               )),
                //                         ],
                //                       ),
                //                       const SizedBox(height: 4),
                //                       Padding(
                //                         padding:
                //                             const EdgeInsets.only(right: 60),
                //                         child: Text(
                //                           '${snapshot.data?.user?.email}',
                //                           style: const TextStyle(
                //                               fontSize: 16,
                //                               color: Colors.white),
                //                         ),
                //                       ),
                //                       const SizedBox(height: 8),
                //
                //                       Consumer<FollowProvider>(
                //                           builder: (_, followProvider, __) {
                //                             if (followProvider.follow!.status ==
                //                                 Status.LOADING) {
                //                               return const Center(
                //                                   child:
                //                                   CircularProgressIndicator());
                //                             }
                //                             if (followProvider.follow!.status ==
                //                                 Status.COMPLETED) {
                //                               return Row(
                //                                 children: [
                //                                   ElevatedButton(
                //                                     onPressed: () {
                //                                       Navigator.pushNamed(context,
                //                                           FollowersList.id);
                //                                     },
                //                                     style: ElevatedButton.styleFrom(
                //                                       backgroundColor:
                //                                       kSecondaryColor,
                //                                       foregroundColor: Colors.black,
                //                                       shape: RoundedRectangleBorder(
                //                                         borderRadius:
                //                                         BorderRadius.circular(
                //                                             16),
                //                                       ),
                //                                     ),
                //                                     child: followProvider
                //                                         .getNumberFollowers() ==
                //                                         null
                //                                         ? const CircularProgressIndicator(
                //                                       strokeWidth: 1,
                //                                     ) // Show loading indicator
                //                                         : Text(
                //                                         'Follower ${followProvider.getNumberFollowers() ?? 0}'),
                //                                   ),
                //                                   const SizedBox(width: 16),
                //                                   ElevatedButton(
                //                                     onPressed: () {
                //                                       Navigator.pushNamed(context,
                //                                           FollowingList.id);
                //                                     },
                //                                     style: ElevatedButton.styleFrom(
                //                                       backgroundColor:
                //                                       kSecondaryColor,
                //                                       foregroundColor: Colors.black,
                //                                       shape: RoundedRectangleBorder(
                //                                         borderRadius:
                //                                         BorderRadius.circular(
                //                                             16),
                //                                       ),
                //                                     ),
                //                                     child: followProvider
                //                                         .getNumberFollowing() ==
                //                                         null
                //                                         ? const CircularProgressIndicator(
                //                                       strokeWidth: 1,
                //                                     ) // Show loading indicator
                //                                         : Text(
                //                                         'Following ${followProvider.getNumberFollowing() ?? 0}'),
                //                                   ),
                //                                 ],
                //                               );
                //                             }
                //                             return Center(
                //                                 child: Text(
                //                                     '${followProvider.follow!.message}'));
                //                           })
                //                     ],
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //     }
                //     if (snapshot.hasError) {
                //       return Text(snapshot.error.toString());
                //     }
                //     return const Text('loading data');
                //   },
                // ),
                Consumer<FollowProvider>(builder: (_, followProvider, __) {
                  if (followProvider.follow!.status == Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (followProvider.follow!.status == Status.COMPLETED) {
                    print('count ${followProvider.getNumberFollowers()}');
                    return Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, FollowersList.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kSecondaryColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: followProvider.getNumberFollowers() == null
                              ? const CircularProgressIndicator(
                                  strokeWidth: 1,
                                ) // Show loading indicator
                              : Text(
                                  'Follower ${followProvider.getNumberFollowers() ?? 0}'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, FollowingList.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kSecondaryColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: followProvider.getNumberFollowing() == null
                              ? const CircularProgressIndicator(
                                  strokeWidth: 1,
                                ) // Show loading indicator
                              : Text(
                                  'Following ${followProvider.getNumberFollowing() ?? 0}'),
                        ),
                      ],
                    );
                  }
                  return Center(
                      child: Text('${followProvider.follow!.message}'));
                }),
                Consumer<LinkProvider>(builder: (_, linkProvider, __) {
                  if (linkProvider.link!.status == Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (linkProvider.link!.status == Status.COMPLETED) {
                    print(linkProvider.link?.data);
                    return SingleChildScrollView(
                      child: SizedBox(
                        height: 350,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(4),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final linkTitle =
                                linkProvider.link!.data?[index].title;
                            final link = linkProvider.link!.data?[index].link;
                            final linkIdToDelete =
                                linkProvider.link!.data?[index].id;
                            print('id ${linkProvider.link!.data?[index].id}');
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                    extentRatio: 0.6,
                                    dismissible: DismissiblePane(
                                      onDismissed: () {},
                                    ),
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          _showEditPage(
                                              linkProvider.link!.data![index]);
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
                                            linkProvider
                                                .deleteLink(linkIdToDelete);
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
                              ),
                            );
                          },
                          itemCount: linkProvider.link!.data!.length,
                        ),
                      ),
                    );
                  }
                  return Center(child: Text('${linkProvider.link!.message}'));
                })
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
