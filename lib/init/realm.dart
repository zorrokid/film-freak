import 'package:film_freak/realm_models/schema.dart';
import 'package:realm/realm.dart';

final config = Configuration.local([
  MediaType.schema,
  Condition.schema,
  CollectionStatus.schema,
  ProductionType.schema,
  CaseType.schema,
  PictureType.schema,
  ReleasePropertyType.schema,
  CollectionItemPropertyType.schema,
  ReleaseProperty.schema,
  CollectionItemProperty.schema,
  ReleasePicture.schema,
  ReleaseMedia.schema,
  CollectionItemMedia.schema,
  Production.schema,
  Release.schema,
  CollectionItem.schema,
], initialDataCallback: initData);
final realm = Realm(config);

void initData(Realm realm) {
  addConditionData(realm);
  addMediaTypeData(realm);
  addCaseTypeData(realm);
  addCollectionStatusData(realm);
  addPictureTypeData(realm);
  addProductionTypeData(realm);
  addCollectionItemPropertyTypeData(realm);
  addReleasePropertyTypeData(realm);
}

void addConditionData(Realm realm) {
  realm.add(Condition(0, "Not set"));
  realm.add(Condition(1, "Bad"));
  realm.add(Condition(2, "Poor"));
  realm.add(Condition(3, "Fair"));
  realm.add(Condition(4, "Good"));
  realm.add(Condition(5, "Mint"));
}

void addMediaTypeData(Realm realm) {
  realm.add(MediaType(0, "Not set"));
  realm.add(MediaType(1, "Blu-ray"));
  realm.add(MediaType(2, "DVD"));
  realm.add(MediaType(3, "VHS"));
  realm.add(MediaType(4, "UHD Blu-ray"));
  realm.add(MediaType(5, "CD"));
  realm.add(MediaType(6, "HD DVD"));
  realm.add(MediaType(7, "Laserdisc"));
  realm.add(MediaType(8, "Betamax"));
}

void addPictureTypeData(Realm realm) {
  realm.add(PictureType(0, "Not set"));
  realm.add(PictureType(1, "Front"));
  realm.add(PictureType(2, "Back"));
  realm.add(PictureType(3, "Inside"));
}

void addProductionTypeData(Realm realm) {
  realm.add(ProductionType(1, "Movie"));
  realm.add(ProductionType(2, "Series"));
  realm.add(ProductionType(3, "Document"));
  realm.add(ProductionType(4, "Music"));
}

void addCaseTypeData(Realm realm) {
  realm.add(CaseType(0, "Not set"));
  realm.add(CaseType(1, "DVD Standard"));
  realm.add(CaseType(2, "Blu-ray Standard"));
  realm.add(CaseType(3, "DVD Slim"));
  realm.add(CaseType(4, "Blu-ray Slim"));
  realm.add(CaseType(5, "Digipack"));
  realm.add(CaseType(6, "Mediabook"));
  realm.add(CaseType(7, "DVD Steelbook"));
  realm.add(CaseType(8, "Blu-ray Steelbook"));
  realm.add(CaseType(9, "Tin case"));
  realm.add(CaseType(10, "Plastic case"));
  realm.add(CaseType(11, "Cardboard case"));
  realm.add(CaseType(12, "Special case"));
}

void addCollectionItemPropertyTypeData(Realm realm) {
  realm.add(CollectionItemPropertyType(1, "Slip Cover"));
  realm.add(CollectionItemPropertyType(2, "Hologram Cover"));
  realm.add(CollectionItemPropertyType(3, "Rental"));
  realm
      .add(CollectionItemPropertyType(4, "Double sided cover with scene list"));
  realm
      .add(CollectionItemPropertyType(5, "Double sided cover with movie info"));
  realm.add(
      CollectionItemPropertyType(6, "Double sided cover with advertisenment"));
  realm.add(CollectionItemPropertyType(7, "Has scene list leaflet"));
  realm.add(CollectionItemPropertyType(8, "Has movie info leaflet"));
  realm.add(CollectionItemPropertyType(9, "Has advertisenment leaflet"));
  realm.add(CollectionItemPropertyType(10, "Has poster"));
}

void addReleasePropertyTypeData(Realm realm) {
  realm.add(ReleasePropertyType(1, "Slip Cover"));
  realm.add(ReleasePropertyType(2, "Hologram Cover"));
  realm.add(ReleasePropertyType(3, "Rental"));
  realm.add(ReleasePropertyType(4, "Double sided cover with scene list"));
  realm.add(ReleasePropertyType(5, "Double sided cover with movie info"));
  realm.add(ReleasePropertyType(6, "Double sided cover with advertisenment"));
  realm.add(ReleasePropertyType(7, "Has scene list leaflet"));
  realm.add(ReleasePropertyType(8, "Has movie info leaflet"));
  realm.add(ReleasePropertyType(9, "Has advertisenment leaflet"));
  realm.add(ReleasePropertyType(10, "Has poster"));
}

void addCollectionStatusData(Realm realm) {
  realm.add(CollectionStatus(0, "Unknown"));
  realm.add(CollectionStatus(1, "Own"));
  realm.add(CollectionStatus(2, "Owned previously"));
  realm.add(CollectionStatus(3, "Trade"));
  realm.add(CollectionStatus(4, "Ordered"));
}
