import 'dart:math';

import 'package:film_freak/screens/process_image/bloc/process_image_bloc.dart';
import 'package:film_freak/screens/process_image/bloc/process_image_event.dart';
import 'package:film_freak/screens/process_image/bloc/process_image_state.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('ProcessImageBloc', () {
    late ProcessImageBloc processImageBloc;

    setUp(() {
      processImageBloc = ProcessImageBloc();
    });
    test('initial state is correct', () {
      expect(processImageBloc.state, const ProcessImageState());
    });

    blocTest<ProcessImageBloc, ProcessImageState>(
        'x and y have correct values after PanStart event',
        build: () => processImageBloc,
        act: (bloc) => bloc.add(const PanStart(x: 1.0, y: 2.0)),
        seed: () => const ProcessImageState(isDown: false, x: 0.0, y: 0.0),
        expect: () => <Matcher>[
              isA<ProcessImageState>()
                  .having((p0) => p0.isDown, "Selection isDown is true", true)
                  .having((p0) => p0.x, 'x has correct value', 1.0)
                  .having((p0) => p0.y, 'y has correct value', 2.0)
            ]);

    blocTest<ProcessImageBloc, ProcessImageState>(
        'x and y have correct values after Pan event',
        build: () => processImageBloc,
        seed: () => const ProcessImageState(
                isDown: true,
                x: 1.0,
                y: 2.0,
                imageWidth: 10,
                imageHeight: 10,
                selectionPoints: [
                  Point(1.0, 2.0),
                  Point(3.0, 4.0),
                  Point(5.0, 6.0),
                  Point(7.0, 8.0),
                ]),
        act: (bloc) => bloc.add(const Pan(x: 1.0, y: 2.0)),
        expect: () => <Matcher>[
              isA<ProcessImageState>()
                  .having((p0) => p0.x, 'x has correct value', 2.0)
                  .having((p0) => p0.y, 'y has correct value', 4.0)
            ]);

    blocTest<ProcessImageBloc, ProcessImageState>(
        'isDown is false after PanEnd event',
        build: () => processImageBloc,
        act: (bloc) => bloc.add(const PanEnd()),
        seed: () => const ProcessImageState(isDown: true),
        expect: () => <Matcher>[
              isA<ProcessImageState>()
                  .having((p0) => p0.isDown, "Selection isDown is false", false)
            ]);
  });
}
