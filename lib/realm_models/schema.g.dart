// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Condition extends _Condition
    with RealmEntity, RealmObjectBase, RealmObject {
  Condition(
    int id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  Condition._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<Condition>> get changes =>
      RealmObjectBase.getChanges<Condition>(this);

  @override
  Condition freeze() => RealmObjectBase.freezeObject<Condition>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Condition._);
    return const SchemaObject(ObjectType.realmObject, Condition, 'Condition', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class CollectionStatus extends _CollectionStatus
    with RealmEntity, RealmObjectBase, RealmObject {
  CollectionStatus(
    int id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  CollectionStatus._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<CollectionStatus>> get changes =>
      RealmObjectBase.getChanges<CollectionStatus>(this);

  @override
  CollectionStatus freeze() =>
      RealmObjectBase.freezeObject<CollectionStatus>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CollectionStatus._);
    return const SchemaObject(
        ObjectType.realmObject, CollectionStatus, 'CollectionStatus', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class ProductionType extends _ProductionType
    with RealmEntity, RealmObjectBase, RealmObject {
  ProductionType(
    int id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  ProductionType._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<ProductionType>> get changes =>
      RealmObjectBase.getChanges<ProductionType>(this);

  @override
  ProductionType freeze() => RealmObjectBase.freezeObject<ProductionType>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ProductionType._);
    return const SchemaObject(
        ObjectType.realmObject, ProductionType, 'ProductionType', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class CaseType extends _CaseType
    with RealmEntity, RealmObjectBase, RealmObject {
  CaseType(
    int id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  CaseType._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<CaseType>> get changes =>
      RealmObjectBase.getChanges<CaseType>(this);

  @override
  CaseType freeze() => RealmObjectBase.freezeObject<CaseType>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CaseType._);
    return const SchemaObject(ObjectType.realmObject, CaseType, 'CaseType', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class MediaType extends _MediaType
    with RealmEntity, RealmObjectBase, RealmObject {
  MediaType(
    int id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  MediaType._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<MediaType>> get changes =>
      RealmObjectBase.getChanges<MediaType>(this);

  @override
  MediaType freeze() => RealmObjectBase.freezeObject<MediaType>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MediaType._);
    return const SchemaObject(ObjectType.realmObject, MediaType, 'MediaType', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class PictureType extends _PictureType
    with RealmEntity, RealmObjectBase, RealmObject {
  PictureType(
    int id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  PictureType._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<PictureType>> get changes =>
      RealmObjectBase.getChanges<PictureType>(this);

  @override
  PictureType freeze() => RealmObjectBase.freezeObject<PictureType>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(PictureType._);
    return const SchemaObject(
        ObjectType.realmObject, PictureType, 'PictureType', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class ReleasePropertyType extends _ReleasePropertyType
    with RealmEntity, RealmObjectBase, RealmObject {
  ReleasePropertyType(
    int id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  ReleasePropertyType._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<ReleasePropertyType>> get changes =>
      RealmObjectBase.getChanges<ReleasePropertyType>(this);

  @override
  ReleasePropertyType freeze() =>
      RealmObjectBase.freezeObject<ReleasePropertyType>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ReleasePropertyType._);
    return const SchemaObject(
        ObjectType.realmObject, ReleasePropertyType, 'ReleasePropertyType', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class CollectionItemPropertyType extends _CollectionItemPropertyType
    with RealmEntity, RealmObjectBase, RealmObject {
  CollectionItemPropertyType(
    int id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  CollectionItemPropertyType._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<CollectionItemPropertyType>> get changes =>
      RealmObjectBase.getChanges<CollectionItemPropertyType>(this);

  @override
  CollectionItemPropertyType freeze() =>
      RealmObjectBase.freezeObject<CollectionItemPropertyType>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CollectionItemPropertyType._);
    return const SchemaObject(ObjectType.realmObject,
        CollectionItemPropertyType, 'CollectionItemPropertyType', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class CollectionItemProperty extends _CollectionItemProperty
    with RealmEntity, RealmObjectBase, RealmObject {
  CollectionItemProperty(
    ObjectId id, {
    CollectionItemPropertyType? propertyType,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'propertyType', propertyType);
  }

  CollectionItemProperty._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  CollectionItemPropertyType? get propertyType =>
      RealmObjectBase.get<CollectionItemPropertyType>(this, 'propertyType')
          as CollectionItemPropertyType?;
  @override
  set propertyType(covariant CollectionItemPropertyType? value) =>
      RealmObjectBase.set(this, 'propertyType', value);

  @override
  Stream<RealmObjectChanges<CollectionItemProperty>> get changes =>
      RealmObjectBase.getChanges<CollectionItemProperty>(this);

  @override
  CollectionItemProperty freeze() =>
      RealmObjectBase.freezeObject<CollectionItemProperty>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CollectionItemProperty._);
    return const SchemaObject(ObjectType.realmObject, CollectionItemProperty,
        'CollectionItemProperty', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('propertyType', RealmPropertyType.object,
          optional: true, linkTarget: 'CollectionItemPropertyType'),
    ]);
  }
}

class ReleaseProperty extends _ReleaseProperty
    with RealmEntity, RealmObjectBase, RealmObject {
  ReleaseProperty(
    ObjectId id, {
    ReleasePropertyType? propertyType,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'propertyType', propertyType);
  }

  ReleaseProperty._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  ReleasePropertyType? get propertyType =>
      RealmObjectBase.get<ReleasePropertyType>(this, 'propertyType')
          as ReleasePropertyType?;
  @override
  set propertyType(covariant ReleasePropertyType? value) =>
      RealmObjectBase.set(this, 'propertyType', value);

  @override
  Stream<RealmObjectChanges<ReleaseProperty>> get changes =>
      RealmObjectBase.getChanges<ReleaseProperty>(this);

  @override
  ReleaseProperty freeze() =>
      RealmObjectBase.freezeObject<ReleaseProperty>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ReleaseProperty._);
    return const SchemaObject(
        ObjectType.realmObject, ReleaseProperty, 'ReleaseProperty', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('propertyType', RealmPropertyType.object,
          optional: true, linkTarget: 'ReleasePropertyType'),
    ]);
  }
}

class ReleasePicture extends _ReleasePicture
    with RealmEntity, RealmObjectBase, RealmObject {
  ReleasePicture(
    ObjectId id,
    String filename, {
    PictureType? pictureType,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'filename', filename);
    RealmObjectBase.set(this, 'pictureType', pictureType);
  }

  ReleasePicture._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get filename =>
      RealmObjectBase.get<String>(this, 'filename') as String;
  @override
  set filename(String value) => RealmObjectBase.set(this, 'filename', value);

  @override
  PictureType? get pictureType =>
      RealmObjectBase.get<PictureType>(this, 'pictureType') as PictureType?;
  @override
  set pictureType(covariant PictureType? value) =>
      RealmObjectBase.set(this, 'pictureType', value);

  @override
  Stream<RealmObjectChanges<ReleasePicture>> get changes =>
      RealmObjectBase.getChanges<ReleasePicture>(this);

  @override
  ReleasePicture freeze() => RealmObjectBase.freezeObject<ReleasePicture>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ReleasePicture._);
    return const SchemaObject(
        ObjectType.realmObject, ReleasePicture, 'ReleasePicture', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('filename', RealmPropertyType.string),
      SchemaProperty('pictureType', RealmPropertyType.object,
          optional: true, linkTarget: 'PictureType'),
    ]);
  }
}

class ReleaseMedia extends _ReleaseMedia
    with RealmEntity, RealmObjectBase, RealmObject {
  ReleaseMedia(
    ObjectId id, {
    MediaType? mediaType,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'mediaType', mediaType);
  }

  ReleaseMedia._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  MediaType? get mediaType =>
      RealmObjectBase.get<MediaType>(this, 'mediaType') as MediaType?;
  @override
  set mediaType(covariant MediaType? value) =>
      RealmObjectBase.set(this, 'mediaType', value);

  @override
  Stream<RealmObjectChanges<ReleaseMedia>> get changes =>
      RealmObjectBase.getChanges<ReleaseMedia>(this);

  @override
  ReleaseMedia freeze() => RealmObjectBase.freezeObject<ReleaseMedia>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ReleaseMedia._);
    return const SchemaObject(
        ObjectType.realmObject, ReleaseMedia, 'ReleaseMedia', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('mediaType', RealmPropertyType.object,
          optional: true, linkTarget: 'MediaType'),
    ]);
  }
}

class CollectionItemMedia extends _CollectionItemMedia
    with RealmEntity, RealmObjectBase, RealmObject {
  CollectionItemMedia(
    ObjectId id, {
    ReleaseMedia? media,
    Condition? condition,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'media', media);
    RealmObjectBase.set(this, 'condition', condition);
  }

  CollectionItemMedia._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  ReleaseMedia? get media =>
      RealmObjectBase.get<ReleaseMedia>(this, 'media') as ReleaseMedia?;
  @override
  set media(covariant ReleaseMedia? value) =>
      RealmObjectBase.set(this, 'media', value);

  @override
  Condition? get condition =>
      RealmObjectBase.get<Condition>(this, 'condition') as Condition?;
  @override
  set condition(covariant Condition? value) =>
      RealmObjectBase.set(this, 'condition', value);

  @override
  Stream<RealmObjectChanges<CollectionItemMedia>> get changes =>
      RealmObjectBase.getChanges<CollectionItemMedia>(this);

  @override
  CollectionItemMedia freeze() =>
      RealmObjectBase.freezeObject<CollectionItemMedia>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CollectionItemMedia._);
    return const SchemaObject(
        ObjectType.realmObject, CollectionItemMedia, 'CollectionItemMedia', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('media', RealmPropertyType.object,
          optional: true, linkTarget: 'ReleaseMedia'),
      SchemaProperty('condition', RealmPropertyType.object,
          optional: true, linkTarget: 'Condition'),
    ]);
  }
}

class Production extends _Production
    with RealmEntity, RealmObjectBase, RealmObject {
  Production(
    ObjectId id,
    String title,
    String originalTitle,
    DateTime createdTime, {
    ProductionType? productionType,
    int? tmdbId,
    String? overView,
    DateTime? releaseDate,
    DateTime? modifiedTime,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'productionType', productionType);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'originalTitle', originalTitle);
    RealmObjectBase.set(this, 'createdTime', createdTime);
    RealmObjectBase.set(this, 'tmdbId', tmdbId);
    RealmObjectBase.set(this, 'overView', overView);
    RealmObjectBase.set(this, 'releaseDate', releaseDate);
    RealmObjectBase.set(this, 'modifiedTime', modifiedTime);
  }

  Production._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  ProductionType? get productionType =>
      RealmObjectBase.get<ProductionType>(this, 'productionType')
          as ProductionType?;
  @override
  set productionType(covariant ProductionType? value) =>
      RealmObjectBase.set(this, 'productionType', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get originalTitle =>
      RealmObjectBase.get<String>(this, 'originalTitle') as String;
  @override
  set originalTitle(String value) =>
      RealmObjectBase.set(this, 'originalTitle', value);

  @override
  DateTime get createdTime =>
      RealmObjectBase.get<DateTime>(this, 'createdTime') as DateTime;
  @override
  set createdTime(DateTime value) =>
      RealmObjectBase.set(this, 'createdTime', value);

  @override
  int? get tmdbId => RealmObjectBase.get<int>(this, 'tmdbId') as int?;
  @override
  set tmdbId(int? value) => RealmObjectBase.set(this, 'tmdbId', value);

  @override
  String? get overView =>
      RealmObjectBase.get<String>(this, 'overView') as String?;
  @override
  set overView(String? value) => RealmObjectBase.set(this, 'overView', value);

  @override
  DateTime? get releaseDate =>
      RealmObjectBase.get<DateTime>(this, 'releaseDate') as DateTime?;
  @override
  set releaseDate(DateTime? value) =>
      RealmObjectBase.set(this, 'releaseDate', value);

  @override
  DateTime? get modifiedTime =>
      RealmObjectBase.get<DateTime>(this, 'modifiedTime') as DateTime?;
  @override
  set modifiedTime(DateTime? value) =>
      RealmObjectBase.set(this, 'modifiedTime', value);

  @override
  Stream<RealmObjectChanges<Production>> get changes =>
      RealmObjectBase.getChanges<Production>(this);

  @override
  Production freeze() => RealmObjectBase.freezeObject<Production>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Production._);
    return const SchemaObject(
        ObjectType.realmObject, Production, 'Production', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('productionType', RealmPropertyType.object,
          optional: true, linkTarget: 'ProductionType'),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('originalTitle', RealmPropertyType.string),
      SchemaProperty('createdTime', RealmPropertyType.timestamp),
      SchemaProperty('tmdbId', RealmPropertyType.int, optional: true),
      SchemaProperty('overView', RealmPropertyType.string, optional: true),
      SchemaProperty('releaseDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('modifiedTime', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }
}

class Release extends _Release with RealmEntity, RealmObjectBase, RealmObject {
  Release(
    ObjectId id,
    String name,
    String barcode,
    DateTime createdTime, {
    CaseType? caseType,
    DateTime? modifiedTime,
    Iterable<Production> productions = const [],
    Iterable<ReleaseMedia> medias = const [],
    Iterable<ReleasePicture> pictures = const [],
    Iterable<ReleaseProperty> properties = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'barcode', barcode);
    RealmObjectBase.set(this, 'caseType', caseType);
    RealmObjectBase.set(this, 'createdTime', createdTime);
    RealmObjectBase.set(this, 'modifiedTime', modifiedTime);
    RealmObjectBase.set<RealmList<Production>>(
        this, 'productions', RealmList<Production>(productions));
    RealmObjectBase.set<RealmList<ReleaseMedia>>(
        this, 'medias', RealmList<ReleaseMedia>(medias));
    RealmObjectBase.set<RealmList<ReleasePicture>>(
        this, 'pictures', RealmList<ReleasePicture>(pictures));
    RealmObjectBase.set<RealmList<ReleaseProperty>>(
        this, 'properties', RealmList<ReleaseProperty>(properties));
  }

  Release._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get barcode => RealmObjectBase.get<String>(this, 'barcode') as String;
  @override
  set barcode(String value) => RealmObjectBase.set(this, 'barcode', value);

  @override
  CaseType? get caseType =>
      RealmObjectBase.get<CaseType>(this, 'caseType') as CaseType?;
  @override
  set caseType(covariant CaseType? value) =>
      RealmObjectBase.set(this, 'caseType', value);

  @override
  DateTime get createdTime =>
      RealmObjectBase.get<DateTime>(this, 'createdTime') as DateTime;
  @override
  set createdTime(DateTime value) =>
      RealmObjectBase.set(this, 'createdTime', value);

  @override
  DateTime? get modifiedTime =>
      RealmObjectBase.get<DateTime>(this, 'modifiedTime') as DateTime?;
  @override
  set modifiedTime(DateTime? value) =>
      RealmObjectBase.set(this, 'modifiedTime', value);

  @override
  RealmList<Production> get productions =>
      RealmObjectBase.get<Production>(this, 'productions')
          as RealmList<Production>;
  @override
  set productions(covariant RealmList<Production> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<ReleaseMedia> get medias =>
      RealmObjectBase.get<ReleaseMedia>(this, 'medias')
          as RealmList<ReleaseMedia>;
  @override
  set medias(covariant RealmList<ReleaseMedia> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<ReleasePicture> get pictures =>
      RealmObjectBase.get<ReleasePicture>(this, 'pictures')
          as RealmList<ReleasePicture>;
  @override
  set pictures(covariant RealmList<ReleasePicture> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<ReleaseProperty> get properties =>
      RealmObjectBase.get<ReleaseProperty>(this, 'properties')
          as RealmList<ReleaseProperty>;
  @override
  set properties(covariant RealmList<ReleaseProperty> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Release>> get changes =>
      RealmObjectBase.getChanges<Release>(this);

  @override
  Release freeze() => RealmObjectBase.freezeObject<Release>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Release._);
    return const SchemaObject(ObjectType.realmObject, Release, 'Release', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('barcode', RealmPropertyType.string),
      SchemaProperty('caseType', RealmPropertyType.object,
          optional: true, linkTarget: 'CaseType'),
      SchemaProperty('createdTime', RealmPropertyType.timestamp),
      SchemaProperty('modifiedTime', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('productions', RealmPropertyType.object,
          linkTarget: 'Production', collectionType: RealmCollectionType.list),
      SchemaProperty('medias', RealmPropertyType.object,
          linkTarget: 'ReleaseMedia', collectionType: RealmCollectionType.list),
      SchemaProperty('pictures', RealmPropertyType.object,
          linkTarget: 'ReleasePicture',
          collectionType: RealmCollectionType.list),
      SchemaProperty('properties', RealmPropertyType.object,
          linkTarget: 'ReleaseProperty',
          collectionType: RealmCollectionType.list),
    ]);
  }
}

class CollectionItem extends _CollectionItem
    with RealmEntity, RealmObjectBase, RealmObject {
  CollectionItem(
    ObjectId id,
    DateTime createdTime, {
    Condition? condition,
    CollectionStatus? status,
    Release? release,
    DateTime? modifiedTime,
    Iterable<CollectionItemMedia> media = const [],
    Iterable<CollectionItemProperty> properties = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'condition', condition);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'release', release);
    RealmObjectBase.set(this, 'createdTime', createdTime);
    RealmObjectBase.set(this, 'modifiedTime', modifiedTime);
    RealmObjectBase.set<RealmList<CollectionItemMedia>>(
        this, 'media', RealmList<CollectionItemMedia>(media));
    RealmObjectBase.set<RealmList<CollectionItemProperty>>(
        this, 'properties', RealmList<CollectionItemProperty>(properties));
  }

  CollectionItem._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  Condition? get condition =>
      RealmObjectBase.get<Condition>(this, 'condition') as Condition?;
  @override
  set condition(covariant Condition? value) =>
      RealmObjectBase.set(this, 'condition', value);

  @override
  CollectionStatus? get status =>
      RealmObjectBase.get<CollectionStatus>(this, 'status')
          as CollectionStatus?;
  @override
  set status(covariant CollectionStatus? value) =>
      RealmObjectBase.set(this, 'status', value);

  @override
  Release? get release =>
      RealmObjectBase.get<Release>(this, 'release') as Release?;
  @override
  set release(covariant Release? value) =>
      RealmObjectBase.set(this, 'release', value);

  @override
  DateTime get createdTime =>
      RealmObjectBase.get<DateTime>(this, 'createdTime') as DateTime;
  @override
  set createdTime(DateTime value) =>
      RealmObjectBase.set(this, 'createdTime', value);

  @override
  DateTime? get modifiedTime =>
      RealmObjectBase.get<DateTime>(this, 'modifiedTime') as DateTime?;
  @override
  set modifiedTime(DateTime? value) =>
      RealmObjectBase.set(this, 'modifiedTime', value);

  @override
  RealmList<CollectionItemMedia> get media =>
      RealmObjectBase.get<CollectionItemMedia>(this, 'media')
          as RealmList<CollectionItemMedia>;
  @override
  set media(covariant RealmList<CollectionItemMedia> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<CollectionItemProperty> get properties =>
      RealmObjectBase.get<CollectionItemProperty>(this, 'properties')
          as RealmList<CollectionItemProperty>;
  @override
  set properties(covariant RealmList<CollectionItemProperty> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<CollectionItem>> get changes =>
      RealmObjectBase.getChanges<CollectionItem>(this);

  @override
  CollectionItem freeze() => RealmObjectBase.freezeObject<CollectionItem>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CollectionItem._);
    return const SchemaObject(
        ObjectType.realmObject, CollectionItem, 'CollectionItem', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('condition', RealmPropertyType.object,
          optional: true, linkTarget: 'Condition'),
      SchemaProperty('status', RealmPropertyType.object,
          optional: true, linkTarget: 'CollectionStatus'),
      SchemaProperty('release', RealmPropertyType.object,
          optional: true, linkTarget: 'Release'),
      SchemaProperty('createdTime', RealmPropertyType.timestamp),
      SchemaProperty('modifiedTime', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('media', RealmPropertyType.object,
          linkTarget: 'CollectionItemMedia',
          collectionType: RealmCollectionType.list),
      SchemaProperty('properties', RealmPropertyType.object,
          linkTarget: 'CollectionItemProperty',
          collectionType: RealmCollectionType.list),
    ]);
  }
}
