import 'dart:convert';

import 'package:film_freak/api-models/login_response.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<LoginResponse> processLogin(String userName, String password) async {
    final result = await http.post(
        Uri(
          scheme: 'https',
          host: 'film-freak-api.fly.dev',
          path: '/api/login',
        ),
        body: jsonEncode(<String, String>{
          'userName': userName,
          'password': password,
        }),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        });

    if (result.body.isEmpty) throw Exception("Login response empty");
    final jsonContent = json.decode(result.body);
    final response = LoginResponse.fromJson(jsonContent);
    return response;
  }
}
