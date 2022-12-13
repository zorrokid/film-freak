import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../entities/production.dart';
import '../../widgets/labelled_text.dart';

class ProductionCard extends StatelessWidget {
  const ProductionCard({super.key, required this.production});
  final Production production;

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
              value: production.title,
            ),
          ]),
          Row(children: [
            LabelledText(
              label: 'Original Title',
              value: production.originalTitle,
            ),
          ]),
          Row(children: [
            LabelledText(
              label: 'Overview',
              value: production.overView ?? '',
            ),
          ]),
          if (production.releaseDate != null)
            Row(children: [
              LabelledText(
                label: 'Release Date',
                value: production.releaseDate.toString(),
              ),
            ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (production.tmdbId != null)
                TextButton(
                  onPressed: () => openTmdbLink(production.tmdbId!),
                  child: const Text("TMDB"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
