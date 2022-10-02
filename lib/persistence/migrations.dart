String initialCreate = '''
  CREATE TABLE releases(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        barcode TEXT, 
        mediaType INTEGER
  )''';

Map<int, String> migrationScripts = {
  // 1: '''CREATE TABLE releases(
  //       id INTEGER PRIMARY KEY,
  //       name TEXT,
  //       barcode TEXT,
  //       mediaType INTEGER;
  //
  //        PRAGMA user_version = 1
  //     )'''
};
