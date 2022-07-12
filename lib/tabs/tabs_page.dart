import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application/api/dio_client.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/model/fake_user_model.dart';
import 'package:flutter_application/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.looks_one), child: Text('User Api')),
            Tab(icon: Icon(Icons.looks_two), text: 'User Data'),
          ],
        ),
        title: const Text('User'),
        backgroundColor: Colors.teal,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UserPage(),
          const UserProfile(),
        ],
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  UserPage({Key? key}) : super(key: key);

  final DioClient _client = DioClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<FakeUserModel?>(
          future: _client.getUser(id: '1'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              FakeUserModel? userInfo = snapshot.data;
              if (userInfo != null) {
                Data userData = userInfo.data;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(userData.avatar),
                    const SizedBox(height: 8.0),
                    Text(
                      '${userInfo.data.firstName} ${userInfo.data.lastName}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      userData.email,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                );
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  Future<UserModel> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userModelString = prefs.getString(user);
    return UserModel.fromJson(json.decode(userModelString!));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel? userInfo = snapshot.data;
          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              int.parse(userInfo!.createdDate!));
          var format = DateFormat("yMd");
          var dateString = format.format(date);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userInfo.name,
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                userInfo.email,
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                dateString,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
