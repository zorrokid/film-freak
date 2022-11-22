import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/release_repository.dart';
import 'package:film_freak/widgets/filter_list.dart';
import 'package:flutter/material.dart';

import '../services/movie_release_service.dart';
import '../utils/dialog_utls.dart';
import 'release_form.dart';
import 'barcode_scanner_view.dart';
import '../widgets/main_drawer.dart';
import '../models/movie_releases_list_filter.dart';
import 'movie_releases_list_view.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() {
    return _ScanViewState();
  }
}

class _ScanViewState extends State<ScanView> {
  final _repository = ReleaseRepository(DatabaseProvider.instance);
  final releaseService = initializeReleaseService();

  Future<List<MovieRelease>> _getLatest() async {
    final latest = await _repository.getLatest(10);
    return latest.toList();
  }

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

  Future<void> _onDelete(int id) async {
    final isOkToDelete = await okToDelete(context, 'Are you sure?',
        'Are you really sure you want to delete the item?');
    if (!isOkToDelete) return;
    await releaseService.deleteRelease(id);
  }

  Future<void> _onEdit(int id) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ReleaseForm(
          id: id,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Scan & view recent'),
      ),
      body: FilterList(
        fetchMethod: _getLatest,
        onDelete: _onDelete,
        onEdit: _onEdit,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: barcodeScan,
        backgroundColor: Colors.green,
        child: const Icon(Icons.search),
      ),
    );
  }
}
