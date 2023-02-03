import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/select_text_from_image_bloc.dart';
import '../bloc/select_text_from_image_event.dart';
import 'image_text_selector.dart';

class SelectTextFromImagePage extends StatelessWidget {
  const SelectTextFromImagePage({
    super.key,
    required this.imagePath,
  });
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = SelectTextFromImageBloc();
        bloc.add(Initialize(imagePath));
        return bloc;
      },
      child: const ImageTextSelector(),
    );
  }
}
