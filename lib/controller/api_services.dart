import 'package:http/http.dart' as http;

import 'dart:convert';

class ApiServices {
  String url(String country) {
    String link;
    if (country == 'India') {
      link = 'https://bms.abglobalmining.co.in/api/1.0/login';
    } else if (country == 'UAE') {
      link = 'https://bms.abglobalmining.co.ae/api/1.0/login';
    } else {
      link = 'https://bms.abglobalmining.co.za/api/1.0/login';
    }
    return link;
  }

  login(
    String phoneNumber,
    String password,
    String country,
  ) async {
    String baseurl = url(country);

    Map<String, dynamic> respond;
    final response = await http.post(
      Uri.parse(baseurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile': phoneNumber,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse["sts"] == "01") {
        respond = {
          "sts": true,
          "msg": jsonResponse["msg"],
          "userid": jsonResponse["user"]["id"].toString()
        };
      } else {
        respond = {
          "sts": false,
          "msg": jsonResponse["msg"],
        };
      }
    } else {
      respond = {"sts": false};

      if (response.statusCode == 400) {
        respond["msg"] = "Bad Request";
      } else if (response.statusCode == 401) {
        respond["msg"] = 'Unauthorized request.';
      } else {
        respond["msg"] = 'Failed to login.';
      }
    }

    return respond;
  }
}
