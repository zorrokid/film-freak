import 'package:film_freak/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/barcode_scan/view/barcode_scan_page.dart';

class FilmFreakApp extends StatelessWidget {
  const FilmFreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(),
      child: const MaterialApp(
        title: 'film_freak',
        home: BarcodeScanPage(),
      ),
    );
  }
}
