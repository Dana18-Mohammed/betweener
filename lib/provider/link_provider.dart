import 'package:flutter/foundation.dart';
import 'package:linktree/core/helpers/api_response.dart';

import '../controller/link_repository .dart';
import '../models/link_response_model.dart';

class LinkProvider extends ChangeNotifier {
  late LinkRepository _linkRepository;
  late ApiResponse<dynamic>? _links;
  Link? mylink;
  LinkProvider() {
    _linkRepository = LinkRepository();
    fetchLinks();
  }
  ApiResponse<dynamic>? get link => _links;

  void fetchLinks() async {
    _links = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await _linkRepository.fetchLinkList();
      print(response);
      _links = ApiResponse.completed(response);
      print(_links);
      notifyListeners();
    } catch (e) {
      _links = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  void addLink(String title, String link, String username) async {
    _links = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await _linkRepository.addLink({
        "title": title,
        "link": link,
        "username": username,
      });
      _links = ApiResponse.completed(response);
      fetchLinks();
      notifyListeners();
    } catch (e) {
      _links = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  void editLink(int? id, String title, String link, String username) async {
    _links = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await _linkRepository.editLink(id!, {
        "title": title,
        "link": link,
        "username": username,
      });
      print(response);
      _links = ApiResponse.completed(response);
      print(_links);
      fetchLinks();
      notifyListeners();
    } catch (e) {
      _links = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  void deleteLink(int? id) async {
    _links = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await _linkRepository.deleteLink(id!);
      print(response);
      _links = ApiResponse.completed(response);
      print(_links);
      fetchLinks();
      notifyListeners();
    } catch (e) {
      _links = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
