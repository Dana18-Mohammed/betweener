import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utilies/constants.dart';
import 'app_exception.dart';

class ApiBaseHelper {
  var responseJson;

  Future<dynamic> get(String url, Map<String, String> headers) async {
    try {
      final response =
          await http.get(Uri.parse(baseUrl + url), headers: headers);
      responseJson = _returnResponse(response);
      print(headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> body,
      Map<String, String> headers) async {
    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          headers: headers, body: body);
      if (response.statusCode == 200) {
      } else {}
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, Map<String, dynamic> body,
      Map<String, String> headers) async {
    try {
      final response = await http.put(Uri.parse(baseUrl + url),
          headers: headers, body: body);
      if (response.statusCode == 200) {
      } else {}
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url, Map<String, String> headers) async {
    try {
      final response =
          await http.delete(Uri.parse(baseUrl + url), headers: headers);
      if (response.statusCode == 200) {
      } else {}
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorisedException(response.body);
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
