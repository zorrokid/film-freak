import 'package:film_freak/domain/entities/collection_item.dart';
import 'package:film_freak/domain/entities/production.dart';
import 'package:film_freak/domain/entities/release.dart';
import 'package:film_freak/domain/entities/release_comment.dart';
import 'package:film_freak/domain/entities/release_media.dart';
import 'package:film_freak/domain/entities/release_picture.dart';
import 'package:film_freak/domain/entities/release_property.dart';
import 'package:film_freak/models/release_view_model.dart';
import 'package:film_freak/screens/view_release/bloc/release_view_bloc.dart';
import 'package:film_freak/screens/view_release/bloc/release_view_event.dart';
import 'package:film_freak/screens/view_release/bloc/release_view_state.dart';
import 'package:film_freak/services/collection_item_service.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'release_view_bloc_test.mocks.dart';

@GenerateMocks([ReleaseService])
@GenerateMocks([CollectionItemService])
void main() {
  group('ReleaseViewBloc', () {
    late ReleaseViewBloc releaseViewBloc;
    late MockReleaseService releaseService;
    late CollectionItemService collectionItemService;

    Release release = Release.empty();
    release.id = 1;
    ReleaseViewModel releaseViewodel = ReleaseViewModel(
      release: release,
      pictures: <ReleasePicture>[],
      properties: <ReleaseProperty>[],
      productions: <Production>[],
      medias: <ReleaseMedia>[],
      comments: <ReleaseComment>[],
      collectionItems: <CollectionItem>[],
    );

    setUp(() {
      releaseService = MockReleaseService();
      collectionItemService = MockCollectionItemService();
      releaseViewBloc = ReleaseViewBloc(
        releaseService: releaseService,
        collectionItemService: collectionItemService,
      );
    });

    test('initial state status is initial', () {
      expect(releaseViewBloc.state.status, ReleaseViewStatus.initial);
    });

    blocTest(
      'LoadRelease',
      setUp: () => when(releaseService.getModel(1))
          .thenAnswer((_) => Future.value(releaseViewodel)),
      build: () => releaseViewBloc,
      act: (bloc) => bloc.add(const LoadRelease(1)),
      expect: () => [
        const TypeMatcher<ReleaseViewState>().having(
            (p0) => p0.status, 'Status: loading', ReleaseViewStatus.loading),
        const TypeMatcher<ReleaseViewState>()
            .having(
                (p0) => p0.status, 'Status: loaded', ReleaseViewStatus.loaded)
            .having((p0) => p0.release, 'Release populated', isNotNull)
            .having(
                (p0) => p0.release,
                'Release has id 1',
                const TypeMatcher<ReleaseViewModel>()
                    .having((p0) => p0.release.id, 'Has id 1', 1))
      ],
    );
  });
}
