import 'package:film_freak/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:film_freak/add_movie_release_form.dart';
import 'package:film_freak/movie_releases_list.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    void pushAdd() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Add new movie release')),
          body: const AddMovieReleaseForm(),
        );
      }));
    }

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Movie releases'),
      ),
      body: const MovieReleasesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: pushAdd,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
