import 'package:flutter/material.dart';
import 'package:linktree/controller/link_controller.dart';
import 'package:linktree/controller/user_controller.dart';
import 'package:linktree/models/Links.dart';
import 'package:linktree/models/user.dart';
import 'package:linktree/views/add_Link.dart';
import 'package:linktree/views/search_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../constants.dart';

class HomeView extends StatefulWidget {
  static String id = '/homeView';
  // final User? user;
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<User> user;
  late Future<List<User>> listUser;
  late Future<List<Links>> links;
  late List<Links> linksData;

  Future<void> _navigateToAddLinkPage() async {
    final addedLink = await Navigator.pushNamed(
      context,
      AddLink.id,
      arguments: linksData,
    );
    if (addedLink != null && addedLink is Links) {
      setState(() {
        if (!linksData.contains(addedLink)) {
          linksData.add(addedLink);
        }
      });
      getLinks(context).then((updatedLinks) {
        setState(() {
          links = Future.value(updatedLinks);
        });
      });
    }
  }

  @override
  void initState() {
    user = getLocalUser();
    setState(() {
      links = getLinks(context);
    });
    linksData = [];
    getLinks(context).then((links) {
      setState(() {
        linksData = links;
      });
    });

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
                '#FF0000', // Color of the toolbar
                'Cancel', // Cancel button text
                true, // Show flash icon
                ScanMode.QR, // Scan mode (QR, BARCODE, or DEFAULT)
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
            FutureBuilder(
              future: links,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 125,
                    child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (index < snapshot.data!.length) {
                            final link = snapshot.data?[index].title;
                            final username = snapshot.data?[index].username;
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
                          } else if (index == snapshot.data!.length) {
                            return GestureDetector(
                              onTap: () {
                                _navigateToAddLinkPage();
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
                        itemCount: snapshot.data!.length + 1),
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const Text('loading');
              },
            ),
          ],
        ),
      ),
    );
  }
}
