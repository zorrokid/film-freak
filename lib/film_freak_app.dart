import 'package:flutter/material.dart';

import 'screens/barcode_scan/view/barcode_scan_page.dart';

class FilmFreakApp extends StatelessWidget {
  const FilmFreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'film_freak',
      home: BarcodeScanPage(),
    );
  }
}
