import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/collection_model.dart';
import 'package:film_freak/main_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => CollectionModel(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Film Freak', home: MainView());
  }
}
