import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class NetworkUtility {
  static Future<String?> getRequest(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<String?> postRequest(
    Uri uri, {
    Map<String, String>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(uri, body: body, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}
