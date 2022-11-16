import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/release_repository.dart';
import 'package:flutter/material.dart';

import '../widgets/recent_list.dart';
import 'release_form.dart';
import 'barcode_scanner_view.dart';
import '../widgets/main_drawer.dart';
import '../models/movie_releases_list_filter.dart';
import 'release_list.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() {
    return _ScanViewState();
  }
}

class _ScanViewState extends State<ScanView> {
  final _repository = ReleaseRepository(DatabaseProvider.instance);

  Future<void> barcodeScan() async {
    final barcode = await Navigator.push<String>(context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    if (barcode == null) return;

    var barcodeExists = await _repository.barcodeExists(barcode);

    if (!mounted) return;

    var route = barcodeExists
        ? MaterialPageRoute<String>(builder: (context) {
            return MovieReleasesList(
                filter: MovieReleasesListFilter(barcode: barcode));
          })
        : MaterialPageRoute<String>(builder: (context) {
            return ReleaseForm(
              barcode: barcode,
            );
          });

    await Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: const RecentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: barcodeScan,
        backgroundColor: Colors.green,
        child: const Icon(Icons.search),
      ),
    );
  }
}
