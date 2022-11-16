import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          title: const Text('About film_freak'),
        ),
        body: const Center(child: Text('Copyright 2022 Mikko Keinänen')));
  }
}
