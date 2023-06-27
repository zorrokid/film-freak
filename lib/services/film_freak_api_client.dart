import 'package:dio/dio.dart';
import '../api-models/token_model.dart';
import '../init/remote_config.dart';

class FilmFreakApiClient {
  // named privavte constructor
  FilmFreakApiClient._privateConstructor() {
    _dio = _initialize();
  }

  // create a singleton instance
  static final _instance = FilmFreakApiClient._privateConstructor();

  // factory constructor to return instance
  factory FilmFreakApiClient() {
    return _instance;
  }

  // no need to be singleton since FilmFreakApiClient is singleton
  late Dio _dio;

  TokenModel? token;

  Dio _initialize() {
    final apiHost = remoteConfig.getString(remoteConfigKeyFilmFreakApiHost);
    final dio = Dio(BaseOptions(
      baseUrl: 'https://$apiHost/api/',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) => _onRequest(options, handler),
      onResponse: (response, handler) => _onResponse(response, handler),
    ));
    return dio;
  }

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (token == null) throw Exception("Token not available");
    options.headers["Authorization"] = "Bearer ${token!.token}";
    return handler.next(options);
  }

  Future<void> _onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      token = await renewToken();
    }
    return handler.next(response);
  }

  Future<TokenModel> renewToken() async {
    if (token == null) throw Exception("Token not available");
    final response = await _dio.post("/refreshtoken", data: {
      "accessToken": token!.token,
      "refreshToken": token!.refreshToken
    });
    return TokenModel.fromJson(response.data);
  }

  Future<void> post(String path, String body) async {
    try {
      await _dio.post(path,
          data: body, options: Options(contentType: 'application/json'));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      }
      rethrow;
    }
  }

  Future<void> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      }
      rethrow;
    }
  }
}
