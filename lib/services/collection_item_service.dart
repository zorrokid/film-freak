import 'package:film_freak/models/collection_item_view_model.dart';
import 'package:film_freak/persistence/repositories/collection_item_comments_repository.dart';
import 'package:film_freak/persistence/repositories/collection_item_properties_repository.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:logging/logging.dart';
import '../entities/collection_item.dart';
import '../persistence/db_provider.dart';
import '../persistence/repositories/collection_items_repository.dart';

CollectionItemService initializeCollectionItemService() {
  final dbProvider = DatabaseProvider.instance;
  return CollectionItemService(
    collectionItemRepository: CollectionItemsRepository(dbProvider),
    collectionItemCommentsRepository:
        CollectionItemCommentsRepository(dbProvider),
    collectionItemPropertiesRepository:
        CollectionItemPropertiesRepository(dbProvider),
    releaseService: initializeReleaseService(),
  );
}

class CollectionItemService {
  CollectionItemService({
    required this.collectionItemRepository,
    required this.collectionItemCommentsRepository,
    required this.collectionItemPropertiesRepository,
    required this.releaseService,
  });

  final log = Logger('CollectionItemService');
  final CollectionItemsRepository collectionItemRepository;
  final CollectionItemCommentsRepository collectionItemCommentsRepository;
  final CollectionItemPropertiesRepository collectionItemPropertiesRepository;
  final ReleaseService releaseService;

  Future<CollectionItemViewModel> getModel(int id) async {
    final collectionItem = await collectionItemRepository.get(id);
    final release = await releaseService.getModel(collectionItem.releaseId!);
    final comments =
        await collectionItemCommentsRepository.getByCollectionItemId(id);
    final properties =
        await collectionItemPropertiesRepository.getByCollectionItemId(id);

    final model = CollectionItemViewModel(
      collectionItem: collectionItem,
      releaseModel: release,
      comments: comments.toList(),
      properties: properties.toList(),
    );
    return model;
  }

  Future<CollectionItem> get(int id) async {
    return await collectionItemRepository.get(id);
  }

  Future<int> upsert(CollectionItem collectionItem) async {
    int? id = collectionItem.id;
    if (id != null) {
      await collectionItemRepository.update(collectionItem);
    } else {
      id = await collectionItemRepository.insert(collectionItem);
    }
    return id;
  }

  Future<bool> delete(int collectionItemId) async {
    final rows = await collectionItemRepository.delete(collectionItemId);
    return rows > 0;
  }

  // Future<Iterable<CollectionItemListModel>> getListModels(
  //     CollectionItemQuerySpecs filter) async {
  //   final collectionItems = await collectionItemRepository.query(filter);
  //   final releaseIds = collectionItems.map((e) => e.releaseId!).toSet();
  //   final releases = await releaseRepository.getByIds(releaseIds);
  //   assert(releases.length == releaseIds.length);
  //   final releaseMap = <int, Release>{};
  //   for (final release in releases) {
  //     releaseMap[release.id!] = release;
  //   }
  //   // TODO
  //   // final movieIds = releases
  //   //     .where((e) => e.productionId != null)
  //   //     .map((e) => e.productionId!)
  //   //     .toSet();
  //   // final movies = await movieRepository.getByIds(movieIds);
  //   // assert(movies.length == movieIds.length);
  //   // final movieMap = <int, Production>{};
  //   // for (final movie in movies) {
  //   //   movieMap[movie.id!] = movie;
  //   // }
  //   final pics = await releasePicturesRepository
  //       .getByReleaseIds(releaseIds); //, [PictureType.coverFront]);

  //   final List<MediaType> mediaTypes = <MediaType>[];

  //   final collectionItemListModels =
  //       collectionItems.map((e) => CollectionItemListModel(
  //             barcode: releaseMap[e.releaseId]!.barcode,
  //             caseType: releaseMap[e.releaseId]!.caseType,
  //             condition: e.condition,
  //             id: e.id!,
  //             mediaTypes: mediaTypes,
  //             name: releaseMap[e.releaseId]!.name,
  //             // TODO
  //             productionNames: [] /*releaseMap[e.releaseId]!.productionId != null
  //                 ? movieMap[releaseMap[e.releaseId]!.productionId]!.title
  //                 : null*/
  //             ,
  //             picFileName: pics.any((p) => p.releaseId == e.id)
  //                 ? pics.firstWhere((p) => p.releaseId == e.id).filename
  //                 : null,
  //           ));

  //   return collectionItemListModels;
  // }
}
