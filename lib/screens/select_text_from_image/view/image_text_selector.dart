import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/spinner.dart';
import '../bloc/select_text_from_image_bloc.dart';
import '../bloc/select_text_from_image_event.dart';
import '../bloc/select_text_from_image_state.dart';
import 'image_text_block_painter.dart';

class ImageTextSelector extends StatefulWidget {
  const ImageTextSelector({super.key});

  @override
  State<ImageTextSelector> createState() {
    return _ImageTextSelectorState();
  }
}

class _ImageTextSelectorState extends State<ImageTextSelector> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void listener(BuildContext context, SelectTextFromImageState state) {
    final bloc = context.read<SelectTextFromImageBloc>();
    switch (state.status) {
      case SelectTextFromImageStatus.initialized:
        bloc.add(ProcessImage());
        break;
      case SelectTextFromImageStatus.isProcessed:
        bloc.add(LoadImage());
        break;
      case SelectTextFromImageStatus.selectionReady:
        Navigator.pop(context, state.textSelection);
        break;
      default:
        // nothing to do
        break;
    }
  }

  Widget buildContent(BuildContext context, SelectTextFromImageState state) {
    if (state.status == SelectTextFromImageStatus.isProcessing ||
        state.status == SelectTextFromImageStatus.loadingImage) {
      return const Spinner();
    }

    final bloc = context.read<SelectTextFromImageBloc>();
    return Column(
      children: [
        Expanded(
          child: state.image != null
              ? FittedBox(
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    child: GestureDetector(
                      onTapDown: (details) =>
                          bloc.add(SelectTextBlock(details.localPosition)),
                      child: SizedBox(
                        width: state.image!.width.toDouble(),
                        height: state.image!.height.toDouble(),
                        child: CustomPaint(
                          painter: ImageTextBlockPainter(
                            image: state.image!,
                            textBlocks: [...state.textBlocks],
                            mode: state.showTextByWords
                                ? TextBlockPainterMode.paintByWord
                                : TextBlockPainterMode.paintByBlock,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(child: Text('No image')),
        ),
        Row(
          children: [
            const Text('Show text by words:'),
            Switch(
              value: state.showTextByWords,
              onChanged: (bool value) => bloc.add(SwitchSelectionMode(value)),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectTextFromImageBloc, SelectTextFromImageState>(
        listener: listener,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Pick text')),
            body: buildContent(context, state),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context
                  .read<SelectTextFromImageBloc>()
                  .add(BuildSelectedText()),
              backgroundColor: Colors.green,
              child: const Icon(Icons.check),
            ),
          );
        });
  }
}
