import 'package:film_freak/screens/process_image/bloc/process_image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/enums/case_type.dart';
import '../../../widgets/spinner.dart';
import '../bloc/process_image_bloc.dart';
import '../bloc/process_image_event.dart';
import '../painters/image_painter.dart';
import '../painters/selection_painter.dart';
import 'case_type_selection.dart';

class ImageProcessView extends StatelessWidget {
  const ImageProcessView({super.key});

  double _getSafeHeight(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    var safeHeight = height - padding.top - padding.bottom;
    return safeHeight;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ProcessImageBloc>(context);

    void onCaseTypeChanged(CaseType selectedCaseType) {
      bloc.add(ChangeCaseType(caseType: selectedCaseType));
    }

    return BlocConsumer<ProcessImageBloc, ProcessImageState>(
      listener: (context, state) {
        switch (state.status) {
          case ProcessImageStatus.initial:
            bloc.add(LoadImage(imagePath: state.imagePath));
            break;
          case ProcessImageStatus.cropped:
            Navigator.of(context).pop();
            break;
          default:
        }
      },
      builder: (context, state) {
        final bloc = BlocProvider.of<ProcessImageBloc>(context);
        return Scaffold(
          appBar: AppBar(title: const Text('Crop image')),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: state.image == null
                      ? const Spinner()
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 0.75 * _getSafeHeight(context),
                          ),
                          child: FittedBox(
                            child: GestureDetector(
                              onPanStart: (details) {
                                bloc.add(PanStart(
                                  x: details.localPosition.dx,
                                  y: details.localPosition.dy,
                                ));
                              },
                              onPanEnd: (details) {
                                bloc.add(const PanEnd());
                              },
                              onPanUpdate: (details) {
                                bloc.add(Pan(
                                  x: details.localPosition.dx,
                                  y: details.localPosition.dy,
                                ));
                              },
                              onDoubleTap: () =>
                                  bloc.add(Crop(context: context)),
                              child: SizedBox(
                                width: state.image!.width.toDouble(),
                                height: state.image!.height.toDouble(),
                                child: CustomPaint(
                                  foregroundPainter: SelectionPainter(
                                      down: state.isDown,
                                      x: state.x,
                                      y: state.y,
                                      selectionPoints: state.selectionPoints),
                                  painter: ImagePainter(
                                    image: state.image!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                CaseTypeSelection(
                  onValueChanged: onCaseTypeChanged,
                  caseType: state.caseType,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => bloc.add(Crop(context: context)),
            backgroundColor: Colors.green,
            child: const Icon(Icons.save),
          ),
        );
      },
    );
  }
}
