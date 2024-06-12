import 'dart:convert';

import 'package:bms/controller/api_services.dart';
import 'package:bms/controller/shared_pref.dart';
import 'package:bms/screens/lognin_screen.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key, required this.selectedCountry, required this.user});
  final String selectedCountry;
  final String user;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
  ApiServices apicontroller = ApiServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.loadRequest(Uri.parse(homeUrl(selectedCountry)));
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) => pageLoadFinished(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () async {
              logout();
            },
            icon: const Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  homeUrl(String country) {
    String encodedUserId = base64EncodeString();
    String link;
    if (country == 'India') {
      link = 'https://bms.abglobalmining.co.in/app/$encodedUserId';
    } else if (country == 'UAE') {
      link = 'https://bms.abglobalmining.co.ae/app/$encodedUserId';
    } else {
      link = 'https://bms.abglobalmining.co.za/app/$encodedUserId';
    }
    print(link.toString());
    return link;
  }

  pageLoadFinished() {
    setState(() {
      _isLoading = false;
    });
  }

  void logout() {
    SharedPref().clearSharedpref();
    numctrl.clear();
    passctrl.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void showSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );
  }

  //create base 64 encodeder
  base64EncodeString() {
    String encodedString = base64.encode(utf8.encode(widget.user.toString()));
    print(encodedString);
    return encodedString.toString();
  }
}
