import 'package:ere_proj/controller/shared_pref.dart';
import 'package:ere_proj/screens/lognin_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.selectedCountry});
  final String selectedCountry;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  WebViewController controller = WebViewController();

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
    String link;
    if (country == 'India') {
      link = 'https://abglobalmining.co.in';
    } else if (country == 'UAE') {
      link = 'https://abglobalmining.co.ae';
    } else {
      link = 'https://abglobalmining.co.za';
    }

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
}
