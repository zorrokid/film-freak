import 'package:flutter/material.dart';

import './tmdb_movie_result.dart';
import './tmdb_search.dart';
import '../../widgets/error_display_widget.dart';
import '../../widgets/spinner.dart';

class TmdbMovieSearchScreen extends StatefulWidget {
  const TmdbMovieSearchScreen({super.key, required this.searchText});
  final String searchText;
  @override
  State<TmdbMovieSearchScreen> createState() {
    return _TmdbMovieSearchScreenState();
  }
}

class _TmdbMovieSearchScreenState extends State<TmdbMovieSearchScreen> {
  late Future<List<TmdbMovieResult>> _futureSearchResult;

  @override
  void initState() {
    super.initState();
    _futureSearchResult = searchMovies(widget.searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
