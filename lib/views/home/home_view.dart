import 'package:flutter/material.dart';
import 'package:linktree/models/link_response_model.dart';
import 'package:linktree/models/user.dart';
import 'package:linktree/provider/link_provider.dart';
import 'package:linktree/views/search/search_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/utilies/constants.dart';
import '../../controller/user_repository.dart';
import '../../core/helpers/api_response.dart';
import '../links/add_Link.dart';

class HomeView extends StatefulWidget {
  static String id = '/homeView';
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<User> user;
  late Future<List<User>> listUser;
  late Future<List<Link>> links;
  LinkProvider linkProvider = LinkProvider();
  void _addLinkToProvider(Link addedLink) {
    final provider = Provider.of<LinkProvider>(context, listen: false);
    provider.addLink(addedLink.title!, addedLink.link!, addedLink.username!);
  }

  Future<void> _navigateToAddLinkPage() async {
    final addedLink = await Navigator.pushNamed(
      context,
      AddLink.id,
    );

    if (addedLink != null && addedLink is Link) {
      _addLinkToProvider(addedLink);
    }
  }

  @override
  void initState() {
    user = UserRepository().getLocalUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.id);
            },
            icon: const Icon(Icons.search, size: 32, color: kPrimaryColor),
          ),
          IconButton(
            onPressed: () async {
              String barcodeScanResult =
                  await FlutterBarcodeScanner.scanBarcode(
                '#FF0000',
                'Cancel',
                true,
                ScanMode.QR,
              );

              if (barcodeScanResult != '-1') {
                print('Scanned QR code: $barcodeScanResult');
              }
            },
            icon: const Icon(Icons.document_scanner_outlined,
                size: 32, color: kPrimaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hello, ${snapshot.data?.user?.name}!'.toUpperCase(),
                          style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return const Text('load');
                }),
            const SizedBox(
              height: 40,
            ),
            FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final username = snapshot.data?.user?.name;
                    return QrImage(
                      data: username ?? '',
                      version: QrVersions.auto,
                      size: 320.0,
                    );
                  }
                  return const Text('load');
                }),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: 250,
              height: 2,
              color: kPrimaryColor,
            ),
            const SizedBox(
              height: 40,
            ),
            Consumer<LinkProvider>(
              builder: (_, linkProvider, __) {
                if (linkProvider.link!.status == Status.LOADING) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (linkProvider.link!.status == Status.COMPLETED) {
                  print(linkProvider.link?.data);
                  return SizedBox(
                    height: 125,
                    child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (index < linkProvider.link!.data!.length) {
                            final link = linkProvider.link!.data![index].title;
                            final username =
                                linkProvider.link!.data![index].username;
                            return Container(
                              width: 140,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: kLightSecondaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Text(
                                    '$link'.toUpperCase(),
                                    style: const TextStyle(
                                        color: kOnSecondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '@$username'.toLowerCase(),
                                    style: const TextStyle(
                                        color: kOnSecondaryColor, fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          } else if (index == linkProvider.link!.data!.length) {
                            return GestureDetector(
                              onTap: () async {
                                await _navigateToAddLinkPage();
                              },
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: kLightSecondaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 35,
                                      weight: 16,
                                      color: kOnSecondaryColor,
                                    ),
                                    Text(
                                      'Add'.toUpperCase(),
                                      style: const TextStyle(
                                        color: kOnSecondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 8,
                          );
                        },
                        itemCount: linkProvider.link!.data!.length + 1),
                  );
                }

                return Center(child: Text('${linkProvider.link!.message}'));
              },
            ),
            // FutureBuilder(
            //   future: links,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return SizedBox(
            //         height: 125,
            //         child: ListView.separated(
            //             padding: const EdgeInsets.all(12),
            //             scrollDirection: Axis.horizontal,
            //             itemBuilder: (context, index) {
            //               if (index < snapshot.data!.length) {
            //                 final link = snapshot.data?[index].title;
            //                 final username = snapshot.data?[index].username;
            //                 return Container(
            //                   width: 140,
            //                   padding: const EdgeInsets.all(12),
            //                   decoration: BoxDecoration(
            //                       color: kLightSecondaryColor,
            //                       borderRadius: BorderRadius.circular(15)),
            //                   child: Column(
            //                     children: [
            //                       Text(
            //                         '$link'.toUpperCase(),
            //                         style: const TextStyle(
            //                             color: kOnSecondaryColor,
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 18),
            //                       ),
            //                       const SizedBox(
            //                         height: 10,
            //                       ),
            //                       Text(
            //                         '@$username'.toLowerCase(),
            //                         style: const TextStyle(
            //                             color: kOnSecondaryColor, fontSize: 14),
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               } else if (index == snapshot.data!.length) {
            //                 return GestureDetector(
            //                   onTap: () {
            //                     _navigateToAddLinkPage();
            //                   },
            //                   child: Container(
            //                     width: 140,
            //                     padding: const EdgeInsets.all(12),
            //                     decoration: BoxDecoration(
            //                       color: kLightSecondaryColor,
            //                       borderRadius: BorderRadius.circular(15),
            //                     ),
            //                     child: Column(
            //                       children: [
            //                         const Icon(
            //                           Icons.add,
            //                           size: 35,
            //                           weight: 16,
            //                           color: kOnSecondaryColor,
            //                         ),
            //                         Text(
            //                           'Add'.toUpperCase(),
            //                           style: const TextStyle(
            //                             color: kOnSecondaryColor,
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 20,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               } else {
            //                 return Container();
            //               }
            //             },
            //             separatorBuilder: (context, index) {
            //               return const SizedBox(
            //                 width: 8,
            //               );
            //             },
            //             itemCount: snapshot.data!.length + 1),
            //       );
            //     }
            //     if (snapshot.hasError) {
            //       return Text(snapshot.error.toString());
            //     }
            //     return const Text('loading');
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
