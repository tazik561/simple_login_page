import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/auth/login_page.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/common/fadu_route.dart';
import 'package:flutter_application/common/validator_extension.dart';
import 'package:flutter_application/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode focusName = FocusNode();
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPass = FocusNode();
  var textEditNameCtl = TextEditingController();
  var textEditEmailCtl = TextEditingController();
  var textEditPasswordCtl = TextEditingController();
  var loading = false;

  var focusEmailFlag = false;
  bool focusPassFlag = false;
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
    focusEmail.addListener(_onEmailFocusChange);
    focusPass.addListener(_onPassFocusChange);
  }

  void _onEmailFocusChange() {
    setState(() {
      focusEmailFlag = !focusEmailFlag;
    });
  }

  void _onPassFocusChange() {
    setState(() {
      focusPassFlag = !focusPassFlag;
    });
  }

  void _registerAction() async {
    var valid = _formKey.currentState!.validate();
    if (valid != true) return;
    final email = textEditEmailCtl.text;
    final pass = textEditPasswordCtl.text;
    final name = textEditNameCtl.text;
    final creationDate = DateTime.now().millisecondsSinceEpoch.toString();
    UserModel model = UserModel(
      email: email,
      password: pass,
      name: name,
      createdDate: creationDate,
    );
    loading = true;
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(user, json.encode(model));
    loading = false;
    setState(() {});

    if (!mounted) return;
    Navigator.of(context).pushReplacement(FadeRoute(page: const LoginPage()));
  }

  @override
  void dispose() {
    focusName.dispose();
    focusEmail.dispose();
    focusPass.dispose();
    textEditEmailCtl.dispose();
    textEditPasswordCtl.dispose();
    textEditNameCtl.dispose();
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
                    "Register",
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
                  focusNode: focusName,
                  controller: textEditNameCtl,
                  validator: (input) =>
                      input!.isNotEmpty ? null : "Fill your name",
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: styleFocus,
                    contentPadding: const EdgeInsets.only(
                        left: 15.0, top: 5.0, right: 5.0, bottom: 4.0),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                TextFormField(
                  focusNode: focusEmail,
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
                  focusNode: focusPass,
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
                  height: height * .05,
                ),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    MaterialButton(
                      onPressed: _registerAction,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.green[600]!)),
                      color: Colors.green[600],
                      child: const Center(
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const SizedBox()
                  ],
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
