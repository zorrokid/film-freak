import 'package:film_freak/realm_models/schema.dart';
import 'package:realm/realm.dart';

import '../init/realm.dart';

class RealmProvider {
  static Realm openRealm() {
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
    return Realm(config);
  }
}
