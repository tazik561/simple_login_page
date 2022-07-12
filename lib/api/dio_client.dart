import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application/model/fake_user_model.dart';

class DioClient {
  final Dio _dio = Dio();

  final _baseUrl = 'https://reqres.in/api';

  Future<FakeUserModel?> getUser({required String id}) async {
    FakeUserModel? user;
    try {
      Response userData = await _dio.get('$_baseUrl/users/$id');
      user = FakeUserModel.fromJson(userData.data);
    } on DioError catch (e) {
      if (e.response != null) {
      } else {
        // Error due to setting up or sending the request
        debugPrint(e.message);
      }
    }
    return user;
  }
}
