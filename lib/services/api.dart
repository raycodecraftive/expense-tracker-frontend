import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiService {
  static Future<Map<String, dynamic>?> update({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      log(body.toString());
      Response data = await http.put(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body));
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> delete({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      log(body.toString());
      Response data = await http.delete(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body));
      return jsonDecode(data.body);
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> post({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      log(body.toString());
      Response data = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json"
        }, // Always set content type as JSON

        body: json.encode(body),
      );
      var convertedData = jsonDecode(data.body);

      if (data.statusCode == 200 || data.statusCode == 201) {
        if (convertedData is List) {
          return {"data": convertedData};
        }
        return convertedData;
      }
      throw Exception(convertedData['message'].toString());
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> get({
    required String url,
  }) async {
    try {
      // api call

      // parse the url
      Uri uri = Uri.parse(url);

      Response data = await http.get(uri);

      //string body

      // convert to map
      var convertedData = jsonDecode(data.body);

      if (convertedData is List) {
        print("adp meka list ekak");
        return {"data": convertedData};
      }
      return convertedData;
    } catch (e) {
      print(e);
      return null;
    }

    // logic
  }
}



// {
//     "id": 1,
//     "description": "uber charges",
//     "amount": 10.5,
//     "category": "travelling",
//     "date": "2024-12-24T15:28:01.729Z"
//   },


