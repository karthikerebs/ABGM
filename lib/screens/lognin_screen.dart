import 'package:bms/controller/api_services.dart';
import 'package:bms/controller/shared_pref.dart';
import 'package:bms/screens/home_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController passctrl = TextEditingController();
TextEditingController numctrl = TextEditingController();
// List<String> countries = ['India', 'UAE', 'South Africa'];
// String selectedCountry = '';
List<String> countries = ['Select a Country', 'India', 'UAE', 'South Africa'];
String selectedCountry = 'Select a Country';

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Image.asset(
                  "assets/images/logo.png",
                  width: 70,
                ),
                const SizedBox(
                  height: 50,
                ),
                DropdownButton<String>(
                  underline: Container(),
                  value: selectedCountry,
                  hint: const Text('Select Country'),
                  items: countries.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newvalue) {
                    if (newvalue != 'Select a Country') {
                      setState(() {
                        selectedCountry = newvalue!;
                      });
                    }
                  },
                ),
                TextFormField(
                  // maxLength: 10,
                  controller: numctrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Mobile Number',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passctrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  height: 60,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minWidth: double.infinity,
                  textColor: Colors.white,
                  color: const Color.fromARGB(255, 213, 90, 90),
                  child: const Text('Login'),
                  onPressed: () async {
                    await login();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    // india
    // var number = '8779766586';
    // var pass = 'RkRJ14D';
    // south africa
    // var number = '8086650141';
    // var pass = 'SmR0957';
    var number = numctrl.text;
    var pass = passctrl.text;
    if (number.isEmpty ||
        pass.isEmpty ||
        selectedCountry.isEmpty ||
        selectedCountry == 'Select a Country') {
      showSnackBar("Please enter valid credentials");
    } else {
      var responseMap =
          await ApiServices().login(number, pass, selectedCountry);
      if (responseMap["sts"] == true) {
        SharedPref sharedpref = SharedPref();
        sharedpref.storeInSharedPref(selectedCountry, responseMap["userid"]);
        final user = responseMap["userid"];

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              selectedCountry: selectedCountry,
              user: user.toString(),
            ),
          ),
        );
      } else {
        showSnackBar(responseMap["msg"]);
      }
    }
  }

  void showSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[400],
        content: Center(child: Text(error)),
      ),
    );
  }
}
