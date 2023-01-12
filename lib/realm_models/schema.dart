import 'package:realm/realm.dart';

part 'schema.g.dart';

@RealmModel()
class _Condition {
  @PrimaryKey()
  late int id;
  late String name;
}

@RealmModel()
class _CollectionStatus {
  @PrimaryKey()
  late int id;
  late String name;
}

@RealmModel()
class _ProductionType {
  @PrimaryKey()
  late int id;
  late String name;
}

@RealmModel()
class _CaseType {
  @PrimaryKey()
  late int id;
  late String name;
}

@RealmModel()
class _MediaType {
  @PrimaryKey()
  late int id;
  late String name;
}

@RealmModel()
class _PictureType {
  @PrimaryKey()
  late int id;
  late String name;
}

@RealmModel()
class _ReleasePropertyType {
  @PrimaryKey()
  late int id;
  late String name;
}

@RealmModel()
class _CollectionItemPropertyType {
  @PrimaryKey()
  late int id;
  late String name;
}

@RealmModel()
class _CollectionItemProperty {
  @PrimaryKey()
  late ObjectId id;
  late _CollectionItemPropertyType? propertyType;
}

@RealmModel()
class _ReleaseProperty {
  @PrimaryKey()
  late ObjectId id;
  late _ReleasePropertyType? propertyType;
}

@RealmModel()
class _ReleasePicture {
  @PrimaryKey()
  late ObjectId id;
  late String filename;
  late _PictureType? pictureType;
}

@RealmModel()
class _ReleaseMedia {
  @PrimaryKey()
  late ObjectId id;
  late _MediaType? mediaType;
}

@RealmModel()
class _CollectionItemMedia {
  @PrimaryKey()
  late ObjectId id;
  late _ReleaseMedia? media;
  late _Condition? condition;
}

@RealmModel()
class _Production {
  @PrimaryKey()
  late ObjectId id;
  late _ProductionType? productionType;
  late String title;
  late String originalTitle;
  late DateTime createdTime;
  late int? tmdbId;
  late String? overView;
  late DateTime? releaseDate;
  late DateTime? modifiedTime;
}

@RealmModel()
class _Release {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late String barcode;
  late _CaseType? caseType;
  late DateTime createdTime;
  late DateTime? modifiedTime;
  late List<_Production> productions;
  late List<_ReleaseMedia> medias;
  late List<_ReleasePicture> pictures;
  late List<_ReleaseProperty> properties;
}

@RealmModel()
class _CollectionItem {
  @PrimaryKey()
  late ObjectId id;
  late _Condition? condition;
  late _CollectionStatus? status;
  late _Release? release;
  late DateTime createdTime;
  late DateTime? modifiedTime;
  late List<_CollectionItemMedia> media;
  late List<_CollectionItemProperty> properties;
}
