import 'package:bloc_test/bloc_test.dart';
import 'package:film_freak/screens/select_text_from_image/bloc/select_text_from_image_bloc.dart';
import 'package:film_freak/screens/select_text_from_image/bloc/select_text_from_image_event.dart';
import 'package:film_freak/screens/select_text_from_image/bloc/select_text_from_image_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builders/selectable_text_builders.dart';

void main() {
  group('Process text from image bloc tests', () {
    late SelectTextFromImageBloc selectTextFromImageBloc;
    setUp(() {
      selectTextFromImageBloc = SelectTextFromImageBloc();
    });

    blocTest("Select text when word select mode is enabled.",
        build: () => selectTextFromImageBloc,
        seed: () =>
            SelectTextFromImageState(showTextByWords: true, textBlocks: [
              SelectableTextBlockBuilder()
                  .withLine(SelectableTextLineBuilder()
                      .withElement(SelectableTextElementBuilder(
                        text: "aaa",
                        isSelected: false,
                      ).build())
                      .withElement(SelectableTextElementBuilder(
                        text: "bbb",
                        isSelected: true,
                      ).build())
                      .build())
                  .build()
            ]),
        act: (bloc) => bloc.add(BuildSelectedText()),
        expect: () => <Matcher>[
              isA<SelectTextFromImageState>()
                  .having(
                    (p0) => p0.status,
                    "Status should be ",
                    SelectTextFromImageStatus.selectionReady,
                  )
                  .having(
                    (p0) => p0.textSelection,
                    "textSelection should contain only selected text",
                    "bbb",
                  ),
            ]);

    blocTest("Select block of text when block select mode is enabled.",
        build: () => selectTextFromImageBloc,
        seed: () =>
            SelectTextFromImageState(showTextByWords: false, textBlocks: [
              SelectableTextBlockBuilder(text: "aaa", isSelected: false)
                  .build(),
              SelectableTextBlockBuilder(text: "bbb", isSelected: true).build(),
            ]),
        act: (bloc) => bloc.add(BuildSelectedText()),
        expect: () => <Matcher>[
              isA<SelectTextFromImageState>().having((p0) => p0.textSelection,
                  "textSelection should contain only selected text", "bbb"),
            ]);
  });
}
