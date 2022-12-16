final migrationScripts = <int, String>{
  // initial create is version 1
  1: '''CREATE TABLE releases(
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          barcode TEXT, 
          caseType INTEGER,
          createdTime DATETIME,
          modifiedTime DATETIME)''',
  2: '''CREATE TABLE productions(
          id INTEGER PRIMARY KEY,
          productionType INTEGER,
          tmdbId INTEGER,
          title STRING,
          originalTitle STRING,
          overview STRING,
          releaseDate DATETIME,
          createdTime DATETIME,
          modifiedTime DATETIME)''',
  3: '''CREATE TABLE releaseProductions(
          releaseId INTEGER,
          productionId INTEGER)''',
  4: '''CREATE TABLE collectionItems(
          id INTEGER PRIMARY KEY,
          releaseId INTEGER NOT NULL,
          condition INTEGER,
          status INTEGER,
          createdTime DATETIME,
          modifiedTime DATETIME)''',
  5: '''CREATE TABLE releasePictures(
          id INTEGER PRIMARY KEY, 
          releaseId INTEGER,
          filename TEXT,
          pictureType INTEGER,
          createdTime DATETIME,
          modifiedTime DATETIME)''',
  6: '''CREATE TABLE releaseProperties(
          id INTEGER PRIMARY KEY,
          releaseId INTEGER,
          propertyType INTEGER,
          createdTime DATETIME,
          modifiedTime DATETIME)''',
  7: '''CREATE TABLE collectionItemProperties(
          id INTEGER PRIMARY KEY,
          collectionItemId INTEGER,
          propertyType INTEGER,
          createdTime DATETIME,
          modifiedTime DATETIME)''',
  8: '''CREATE TABLE releaseComments(
          id INTEGER PRIMARY KEY,
          releaseId INTEGER,
          comment TEXT,
          createdTime DATETIME,
          modifiedTime DATETIME)''',
  9: '''CREATE TABLE collectionItemComments(
          id INTEGER PRIMARY KEY,
          collectionItemId INTEGER,
          comment TEXT,
          createdTime DATETIME,
          modifiedTime DATETIME)''',
  10: '''CREATE TABLE releaseMedias(
          id INTEGER PRIMARY KEY, 
          releaseId INTEGER,
          mediaType INTEGER,
          condition INTEGER,
          createdTime DATETIME,
          modifiedTime DATETIME)''',
};
