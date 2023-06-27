import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/tmdb_movie_result.dart';
import '../../init/remote_config.dart';
import 'tmdb_configuration.dart';

const String tmdbHostUrl = 'api.themoviedb.org';
const int tmdbDbApiVersion = 3;

class TmdbSearchService {
  final tmdbApiKey = remoteConfig.getString(remoteConfigKeyTmdbApiKey);
  Future<List<TmdbMovieResult>> getMovies(String searchText) async {
    final result = await http.get(
      Uri(
        scheme: 'https',
        host: 'api.themoviedb.org',
        path: '/$tmdbDbApiVersion/search/movie',
        queryParameters: {'api_key': tmdbApiKey, 'query': searchText},
      ),
    );
    if (result.body.isEmpty) return [];
    final jsonContent = json.decode(result.body);
    final moviesResultJson = jsonContent['results'] as List;
    final moviesResult =
        moviesResultJson.map((e) => TmdbMovieResult.fromJson(e)).toList();
    return moviesResult;
  }

  Future<TmdbConfiguration?> getConfiguration() async {
    final result = await http.get(
      Uri(
        scheme: 'https',
        host: 'api.themoviedb.org',
        path: '/$tmdbDbApiVersion/configuration',
        queryParameters: {'api_key': tmdbApiKey},
      ),
    );
    if (result.body.isEmpty) return null;
    final jsonContent = json.decode(result.body);
    final config = TmdbConfiguration.fromJson(jsonContent['images']);
    return config;
  }
}
