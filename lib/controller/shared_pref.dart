import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  storeInSharedPref(String country, String userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('country', country);
    await prefs.setString('userid', userid);
  }

  clearSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
