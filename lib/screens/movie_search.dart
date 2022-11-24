import 'dart:convert';

import 'package:film_freak/init/remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/error_display_widget.dart';
import '../widgets/main_drawer.dart';
import '../widgets/spinner.dart';

class MovieSearchResult {
  MovieSearchResult(
      {required this.id,
      required this.title,
      required this.originalTitle,
      required this.overview,
      required this.releaseDate,
      required this.isAdult,
      required this.posterPath});
  int id;
  String title;
  String originalTitle;
  String overview;
  String releaseDate;
  bool isAdult;
  String posterPath;

  static MovieSearchResult fromJson(Map<String, Object?> json) {
    return MovieSearchResult(
        id: json['id'] as int,
        title: json['title'] as String,
        originalTitle: json['original_title'] as String,
        overview: json['overview'] as String,
        releaseDate: json['release_date'] as String,
        isAdult: json['adult'] as bool,
        posterPath: json['poster_path'] as String);
  }
}

const String tmdbApiBaseUrl = 'https://api.themoviedb.org';
const int tmdbDbApiVersion = 3;

class MovieSearch extends StatefulWidget {
  const MovieSearch({super.key, required this.searchText});
  final String searchText;
  @override
  State<MovieSearch> createState() {
    return _MovieSearchState();
  }
}

class _MovieSearchState extends State<MovieSearch> {
  late Future<List<MovieSearchResult>> _futureSearchResult;

  @override
  void initState() {
    super.initState();
    _futureSearchResult = _searchMovies();
  }

  Future<List<MovieSearchResult>> _searchMovies() async {
    final tmdbApiKey = remoteConfig.getString('tmdb_api_key');
    final query =
        '$tmdbApiBaseUrl/$tmdbDbApiVersion/search/movie?api_key=$tmdbApiKey&query=${widget.searchText}';
    final result = await http.get(Uri.parse(query));
    if (result.body.isEmpty) return [];
    final jsonContent = json.decode(result.body);
    final moviesResultJson = jsonContent['results'] as List;
    final moviesResult =
        moviesResultJson.map((e) => MovieSearchResult.fromJson(e)).toList();
    return moviesResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: FutureBuilder(
        future: _futureSearchResult,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorDisplayWidget(
              snapshot.error.toString(),
            );
          }
          if (!snapshot.hasData) {
            return const Spinner();
          }
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(results[index].title),
              );
            },
          );
        },
      ),
    );
  }
}
