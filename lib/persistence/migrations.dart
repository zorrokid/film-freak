import '../models/enums.dart';

Map<int, String> migrationScripts = {
  // initial create is version 1
  1: '''CREATE TABLE releases(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        barcode TEXT, 
        mediaType INTEGER
  )''',
  2: 'ALTER TABLE releases ADD COLUMN caseType INTEGER',
  3: 'UPDATE releases SET caseType = ${CaseType.unknown.index}',
};
