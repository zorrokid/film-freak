import 'package:film_freak/entities/movie.dart';
import 'package:film_freak/widgets/labelled_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});
  final Movie movie;

  Future<void> openTmdbLink(int tmdbId) async {
    final url = Uri(
        scheme: 'https', host: 'www.themoviedb.org', path: '/movie/$tmdbId');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(children: [
            LabelledText(
              label: 'Title',
              value: movie.title,
            ),
          ]),
          Row(children: [
            LabelledText(
              label: 'Original Title',
              value: movie.originalTitle,
            ),
          ]),
          Row(children: [
            LabelledText(
              label: 'Overview',
              value: movie.overView ?? '',
            ),
          ]),
          if (movie.releaseDate != null)
            Row(children: [
              LabelledText(
                label: 'Release Date',
                value: movie.releaseDate.toString(),
              ),
            ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (movie.tmdbId != null)
                TextButton(
                  onPressed: () => openTmdbLink(movie.tmdbId!),
                  child: const Text("TMDB"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
