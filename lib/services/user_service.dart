import 'dart:convert';

import 'package:film_freak/api-models/token_model.dart';
import 'package:http/http.dart' as http;

import '../init/remote_config.dart';

class UserService {
  final apiHost = remoteConfig.getString(remoteConfigKeyFilmFreakApiHost);

  Future<TokenModel> processLogin(String userName, String password) async {
    final result = await http.post(
        Uri(
          scheme: 'https',
          host: apiHost,
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
    final response = TokenModel.fromJson(jsonContent);
    return response;
  }
}
