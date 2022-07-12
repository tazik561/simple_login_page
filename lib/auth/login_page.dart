import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/common/fadu_route.dart';
import 'package:flutter_application/common/validator_extension.dart';
import 'package:flutter_application/model/user_model.dart';
import 'package:flutter_application/tabs/tabs_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var textEditEmailCtl = TextEditingController();
  var textEditPasswordCtl = TextEditingController();

  var styleUnFocus = TextStyle(
    color: Colors.grey[400],
  );
  var styleFocus = const TextStyle(color: Colors.green);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
    );
  }

  void _loginAction() async {
    var valid = _formKey.currentState!.validate();
    if (valid != true) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userModelString = prefs.getString(user);
      final userModel = UserModel.fromJson(json.decode(userModelString!));
      final email = textEditEmailCtl.text;
      final pass = textEditPasswordCtl.text;
      if (userModel.email == email && userModel.password == pass) {
        if (!mounted) return;

        Navigator.of(context)
            .pushReplacement(FadeRoute(page: const TabsPage()));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something wrong happen!!!")));
      }
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    // Navigator.pushReplacement(context, FadeRoute(page: CategoriesPage()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(width * 0.1),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: height * 0.05,
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Login to your account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .05,
                ),
                TextFormField(
                  controller: textEditEmailCtl,
                  validator: (input) =>
                      input!.isValidEmail() ? null : "Check your email",
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: styleFocus,
                    contentPadding: const EdgeInsets.only(
                        left: 15.0, top: 5.0, right: 5.0, bottom: 4.0),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                TextField(
                  controller: textEditPasswordCtl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: styleFocus,
                    contentPadding: const EdgeInsets.only(
                        left: 15.0, top: 5.0, right: 5.0, bottom: 4.0),
                    suffixIcon: const Icon(
                      Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Your Password?",
                      style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    )),
                SizedBox(
                  height: height * .05,
                ),
                MaterialButton(
                  onPressed: _loginAction,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.green[600]!)),
                  color: Colors.green[600],
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                MaterialButton(
                  onPressed: () {},
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.green[100]!)),
                  color: Colors.green[100],
                  child: Center(
                    child: Text(
                      "Don't have an account yet?",
                      style:
                          TextStyle(color: Colors.green[800], fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .05,
                ),
                const Text.rich(
                  TextSpan(
                      text: "By continuing, you agree to Eatiquette's\n",
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                      children: [
                        TextSpan(
                          text: "Terms of Use ",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "and ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
