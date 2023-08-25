import 'package:flutter/material.dart';
import '../../../core/utilies/constants.dart';
import 'package:linktree/controller/serach_user.dart';
import 'package:linktree/views/search/user_search_profile.dart';
import '../../models/followee_response_model.dart';
import '../../models/user.dart';

class SearchPage extends StatefulWidget {
  static String id = '/Search';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController nameController = TextEditingController();
  late List<UserClass> matchedUsers = [];
  late Followee followeeData;
  void _searchUsers(BuildContext context) async {
    String nameQuery = nameController.text;

    try {
      List<UserClass> users = await searchByUser(nameQuery);
      setState(() {
        matchedUsers = users;
      });
    } catch (e) {
      Text(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter a name to search for users',
              ),
            ),
            ElevatedButton(
              onPressed: () => _searchUsers(context),
              child: const Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchedUsers.length,
                itemBuilder: (context, index) {
                  if (matchedUsers.isNotEmpty) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Usersearch(user: matchedUsers[index]),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(matchedUsers[index].name!),
                        subtitle: Text(matchedUsers[index].email!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'View Profile',
                              style: TextStyle(color: kDangerColor),
                            ),
                            SizedBox(width: 4),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No Users Found,try again'),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
