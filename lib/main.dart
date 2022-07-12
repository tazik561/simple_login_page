import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/auth/login_page.dart';
import 'package:flutter_application/auth/register_page.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/common/fadu_route.dart';
import 'package:flutter_application/common/validator_extension.dart';
import 'package:flutter_application/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[800]!, width: 1.0),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    voidcheckLogin();
  }

  voidcheckLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userModelString = prefs.getString(user);

    if (userModelString != null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(FadeRoute(page: const LoginPage()));
    } else {
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(FadeRoute(page: const RegisterPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
