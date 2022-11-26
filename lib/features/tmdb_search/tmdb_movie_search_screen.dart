import 'package:film_freak/features/tmdb_search/tmdb_configuration.dart';
import 'package:flutter/material.dart';
import './tmdb_movie_result.dart';
import 'tmdb_search_service.dart';
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
  final _searchService = TmdbSearchService();

  late Future<List<TmdbMovieResult>> _futureSearchResult;
  late Future<TmdbConfiguration?> _futureConfiguration;

  TmdbMovieResult? _selection;

  @override
  void initState() {
    super.initState();
    _futureSearchResult = _searchService.getMovies(widget.searchText);
    _futureConfiguration = _searchService.getConfiguration();
  }

  void onSelectionDone(BuildContext context) {
    Navigator.pop(context, _selection);
  }

  void setSelected(TmdbMovieResult selected) {
    setState(() {
      _selection = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: FutureBuilder(
        future: Future.wait([_futureConfiguration, _futureSearchResult]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError) {
            return ErrorDisplayWidget(
              snapshot.error.toString(),
            );
          }
          if (!snapshot.hasData) {
            return const Spinner();
          }
          final TmdbConfiguration config = snapshot.data![0];
          final List<TmdbMovieResult> results = snapshot.data![1];
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(results[index].title),
                subtitle: Text(results[index].originalTitle),
                leading: results[index].posterPath.isNotEmpty
                    ? Image.network(
                        '${config.secureBaseUrl}${config.posterSizes[0]}/${results[index].posterPath}')
                    : const Icon(Icons.image),
                trailing: _selection == results[index]
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => setSelected(results[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSelectionDone(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}
