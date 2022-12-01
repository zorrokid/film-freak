import 'package:film_freak/enums/picture_type.dart';
import 'package:film_freak/models/list_models/collection_item_list_model.dart';
import 'package:film_freak/models/collection_item_query_specs.dart';
import 'package:film_freak/persistence/repositories/movie_repository.dart';
import 'package:logging/logging.dart';

import '../entities/collection_item.dart';
import '../entities/movie.dart';
import '../entities/movie_release.dart';
import '../persistence/db_provider.dart';
import '../persistence/repositories/collection_item_repository.dart';
import '../persistence/repositories/release_pictures_repository.dart';
import '../persistence/repositories/release_properties_repository.dart';
import '../persistence/repositories/release_repository.dart';

CollectionItemService initializeCollectionItemService() {
  final dbProvider = DatabaseProvider.instance;
  return CollectionItemService(
    collectionItemRepository: CollectionItemRepository(dbProvider),
    releaseRepository: ReleaseRepository(dbProvider),
    releasePicturesRepository: ReleasePicturesRepository(dbProvider),
    releasePropertiesRepository: ReleasePropertiesRepository(dbProvider),
    movieRepository: MovieRepository(dbProvider),
  );
}

class CollectionItemService {
  CollectionItemService({
    required this.collectionItemRepository,
    required this.releaseRepository,
    required this.releasePicturesRepository,
    required this.releasePropertiesRepository,
    required this.movieRepository,
  });

  final log = Logger('CollectionItemService');
  final CollectionItemRepository collectionItemRepository;
  final ReleaseRepository releaseRepository;
  final ReleasePicturesRepository releasePicturesRepository;
  final ReleasePropertiesRepository releasePropertiesRepository;
  final MovieRepository movieRepository;

  Future<CollectionItem> get(int id) async {
    return await collectionItemRepository.get(id, CollectionItem.fromMap);
  }

  Future<int> upsert(CollectionItem viewModel) async {
    int? id = viewModel.id;
    if (id != null) {
      await collectionItemRepository.update(viewModel);
    } else {
      id = await collectionItemRepository.insert(viewModel);
    }
    return id;
  }

  Future<bool> delete(int collectionItemId) async {
    final rows = await collectionItemRepository.delete(collectionItemId);
    return rows > 0;
  }

  Future<Iterable<CollectionItemListModel>> getListModels(
      CollectionItemQuerySpecs? filter) async {
    final collectionItems = await collectionItemRepository.query(filter);
    final releaseIds = collectionItems.map((e) => e.releaseId!).toSet();
    final releases = await releaseRepository.getByIds(releaseIds);
    final releaseMap = <int, MovieRelease>{};
    for (final release in releases) {
      releaseMap[release.id!] = release;
    }
    final movieIds =
        releases.where((e) => e.movieId != null).map((e) => e.movieId!).toSet();
    final movies = await movieRepository.getByIds(movieIds);
    final movieMap = <int, Movie>{};
    for (final movie in movies) {
      movieMap[movie.id!] = movie;
    }
    final pics = await releasePicturesRepository
        .getByReleaseIds(releaseIds, [PictureType.coverFront]);

    final collectionItemListModels =
        collectionItems.map((e) => CollectionItemListModel(
              barcode: releaseMap[e.releaseId]!.barcode,
              caseType: releaseMap[e.releaseId]!.caseType,
              condition: e.condition,
              id: e.id!,
              mediaType: releaseMap[e.releaseId]!.mediaType,
              name: releaseMap[e.releaseId]!.name,
              movieName: releaseMap[e.releaseId]!.movieId != null
                  ? movieMap[releaseMap[e.releaseId]!.movieId]!.title
                  : null,
              picFileName: pics.any((p) => p.releaseId == e.id)
                  ? pics.firstWhere((p) => p.releaseId == e.id).filename
                  : null,
            ));

    return collectionItemListModels;
  }

  Future<Iterable<CollectionItemListModel>> getLatest(int top) async {
    final filter =
        CollectionItemQuerySpecs(top: top, orderBy: OrderByEnum.latest);
    return getListModels(filter);
  }
}
