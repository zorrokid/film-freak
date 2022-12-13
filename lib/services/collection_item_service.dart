import 'package:film_freak/enums/media_type.dart';
import 'package:film_freak/enums/picture_type.dart';
import 'package:film_freak/models/list_models/collection_item_list_model.dart';
import 'package:film_freak/persistence/query_specs/collection_item_query_specs.dart';
import 'package:film_freak/persistence/repositories/productions_repository.dart';
import 'package:logging/logging.dart';

import '../entities/collection_item.dart';
import '../entities/production.dart';
import '../entities/release.dart';
import '../persistence/db_provider.dart';
import '../persistence/repositories/collection_items_repository.dart';
import '../persistence/repositories/release_pictures_repository.dart';
import '../persistence/repositories/release_properties_repository.dart';
import '../persistence/repositories/releases_repository.dart';

CollectionItemService initializeCollectionItemService() {
  final dbProvider = DatabaseProvider.instance;
  return CollectionItemService(
    collectionItemRepository: CollectionItemsRepository(dbProvider),
    releaseRepository: ReleasesRepository(dbProvider),
    releasePicturesRepository: ReleasePicturesRepository(dbProvider),
    releasePropertiesRepository: ReleasePropertiesRepository(dbProvider),
    movieRepository: ProductionsRepository(dbProvider),
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
  final CollectionItemsRepository collectionItemRepository;
  final ReleasesRepository releaseRepository;
  final ReleasePicturesRepository releasePicturesRepository;
  final ReleasePropertiesRepository releasePropertiesRepository;
  final ProductionsRepository movieRepository;

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
      CollectionItemQuerySpecs filter) async {
    final collectionItems = await collectionItemRepository.query(filter);
    final releaseIds = collectionItems.map((e) => e.releaseId!).toSet();
    final releases = await releaseRepository.getByIds(releaseIds);
    assert(releases.length == releaseIds.length);
    final releaseMap = <int, Release>{};
    for (final release in releases) {
      releaseMap[release.id!] = release;
    }
    final movieIds = releases
        .where((e) => e.productionId != null)
        .map((e) => e.productionId!)
        .toSet();
    final movies = await movieRepository.getByIds(movieIds);
    assert(movies.length == movieIds.length);
    final movieMap = <int, Production>{};
    for (final movie in movies) {
      movieMap[movie.id!] = movie;
    }
    final pics = await releasePicturesRepository
        .getByReleaseIds(releaseIds, [PictureType.coverFront]);

    final List<MediaType> mediaTypes = <MediaType>[];

    final collectionItemListModels =
        collectionItems.map((e) => CollectionItemListModel(
              barcode: releaseMap[e.releaseId]!.barcode,
              caseType: releaseMap[e.releaseId]!.caseType,
              condition: e.condition,
              id: e.id!,
              mediaTypes: mediaTypes,
              name: releaseMap[e.releaseId]!.name,
              productionNames: releaseMap[e.releaseId]!.productionId != null
                  ? movieMap[releaseMap[e.releaseId]!.productionId]!.title
                  : null,
              picFileName: pics.any((p) => p.releaseId == e.id)
                  ? pics.firstWhere((p) => p.releaseId == e.id).filename
                  : null,
            ));

    return collectionItemListModels;
  }
}
