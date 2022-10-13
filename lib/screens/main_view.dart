import 'package:film_freak/widgets/main_drawer.dart';
import 'package:film_freak/screens/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:film_freak/screens/add_movie_release_form.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    void pushAdd() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const AddMovieReleaseForm();
      }));
    }

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Movie releases'),
      ),
      body: const ScanView(),
      floatingActionButton: FloatingActionButton(
        onPressed: pushAdd,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
