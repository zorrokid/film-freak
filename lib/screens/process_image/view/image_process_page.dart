import 'package:film_freak/screens/process_image/bloc/process_image_event.dart';
import 'package:film_freak/screens/process_image/view/image_process_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/process_image_bloc.dart';

class ImageProcessPage extends StatelessWidget {
  const ImageProcessPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = ProcessImageBloc();
        bloc.add(InitState(imagePath: imagePath));
        return bloc;
      },
      child: const ImageProcessView(),
    );
  }
}
