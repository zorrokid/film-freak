import 'package:logging/logging.dart';
import '../domain/entities/collection_item_media.dart';
import '../domain/enums/condition.dart';
import '../models/collection_item_edit_view_model.dart';
import '../models/collection_item_media_view_model.dart';
import '../models/collection_item_view_model.dart';
import '../persistence/repositories/collection_item_comments_repository.dart';
import '../persistence/repositories/collection_item_media_repository.dart';
import '../persistence/repositories/collection_item_properties_repository.dart';
import '../persistence/repositories/release_medias_repository.dart';
import '../services/release_service.dart';
import '../domain/entities/collection_item.dart';
import '../models/collection_item_save_model.dart';
import '../persistence/db_provider.dart';
import '../persistence/repositories/collection_items_repository.dart';

CollectionItemService initializeCollectionItemService() {
  final dbProvider = DatabaseProviderSqflite.instance;
  return CollectionItemService(
    collectionItemRepository: CollectionItemsRepository(dbProvider),
    collectionItemCommentsRepository:
        CollectionItemCommentsRepository(dbProvider),
    collectionItemPropertiesRepository:
        CollectionItemPropertiesRepository(dbProvider),
    collectionItemMediaRepository: CollectionItemMediaRepository(dbProvider),
    releaseMediasRepository: ReleaseMediasRepository(dbProvider),
    releaseService: initializeReleaseService(),
  );
}

class CollectionItemService {
  CollectionItemService({
    required this.collectionItemRepository,
    required this.collectionItemCommentsRepository,
    required this.collectionItemPropertiesRepository,
    required this.collectionItemMediaRepository,
    required this.releaseMediasRepository,
    required this.releaseService,
  });

  final log = Logger('CollectionItemService');
  final CollectionItemsRepository collectionItemRepository;
  final CollectionItemCommentsRepository collectionItemCommentsRepository;
  final CollectionItemPropertiesRepository collectionItemPropertiesRepository;
  final CollectionItemMediaRepository collectionItemMediaRepository;
  final ReleaseMediasRepository releaseMediasRepository;
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

  Future<CollectionItemEditViewModel> getEditModel(int collectionItemId) async {
    final collectionItem = await collectionItemRepository.get(collectionItemId);
    final properties = await collectionItemPropertiesRepository
        .getByCollectionItemId(collectionItemId);
    final releaseMedia =
        await releaseMediasRepository.getByReleaseId(collectionItem.releaseId!);
    final media = await collectionItemMediaRepository
        .getByCollectionItemId(collectionItemId);
    final mediaViewModel = media
        .map(
          (e) => CollectionItemMediaViewModel(
              releaseMedia:
                  releaseMedia.where((rm) => rm.id == e.releaseMediaId).single,
              collectionItemMedia: e),
        )
        .toList();
    final model = CollectionItemEditViewModel(
      collectionItem: collectionItem,
      properties: properties.toList(),
      media: mediaViewModel,
    );
    return model;
  }

  Future<CollectionItemEditViewModel> initializeAddModel(int releaseId) async {
    final releaseMedia =
        await releaseMediasRepository.getByReleaseId(releaseId);
    final collectionItemMedia = releaseMedia.map(
      (e) => CollectionItemMediaViewModel(
        releaseMedia: e,
        collectionItemMedia: CollectionItemMedia(
          condition: Condition.unknown,
          releaseMediaId: e.id!,
        ),
      ),
    );
    return CollectionItemEditViewModel(
      collectionItem: CollectionItem.empty(releaseId),
      properties: [],
      media: collectionItemMedia.toList(),
    );
  }

  Future<CollectionItem> get(int id) async {
    return await collectionItemRepository.get(id);
  }

  Future<int> upsert(CollectionItemSaveModel saveModel) async {
    int? id = saveModel.collectionItem.id;
    if (id != null) {
      await collectionItemRepository.update(saveModel.collectionItem);
    } else {
      id = await collectionItemRepository.insert(saveModel.collectionItem);
    }
    for (CollectionItemMedia media in saveModel.media) {
      media.collectionItemId = id;
      collectionItemMediaRepository.upsert(media);
    }
    // TODO add/update properties
    return id;
  }

  Future<int> delete(int collectionItemId) async {
    return await collectionItemRepository.delete(collectionItemId);
  }
}
