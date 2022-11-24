import 'dart:convert';

import 'package:http/http.dart' as http;

import './tmdb_movie_result.dart';
import '../../init/remote_config.dart';

const String tmdbApiBaseUrl = 'https://api.themoviedb.org';
const int tmdbDbApiVersion = 3;

Future<List<TmdbMovieResult>> searchMovies(String searchText) async {
  final tmdbApiKey = remoteConfig.getString('tmdb_api_key');
  final query =
      '$tmdbApiBaseUrl/$tmdbDbApiVersion/search/movie?api_key=$tmdbApiKey&query=$searchText';
  final result = await http.get(Uri.parse(query));
  if (result.body.isEmpty) return [];
  final jsonContent = json.decode(result.body);
  final moviesResultJson = jsonContent['results'] as List;
  final moviesResult =
      moviesResultJson.map((e) => TmdbMovieResult.fromJson(e)).toList();
  return moviesResult;
}
