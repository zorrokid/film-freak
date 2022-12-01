final migrationScripts = <int, String>{
  // initial create is version 1
  1: '''CREATE TABLE releases(
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          barcode TEXT, 
          mediaType INTEGER
      )''',
  2: 'ALTER TABLE releases ADD COLUMN caseType INTEGER',
  3: 'ALTER TABLE releases ADD COLUMN condition INTEGER',
  4: 'ALTER TABLE releases ADD COLUMN notes TEXT',
  5: 'ALTER TABLE releases ADD COLUMN createdTime DATETIME',
  6: 'ALTER TABLE releases ADD COLUMN hasSlipCover INTEGER',
  7: 'UPDATE releases SET hasSlipCover = 0 WHERE hasSlipCover IS NULL',
  8: 'UPDATE releases SET createdTime = CURRENT_TIMESTAMP WHERE createdTime IS NULL',
  9: 'UPDATE releases SET createdTime = CURRENT_TIMESTAMP WHERE createdTime IS NULL',
  10: '''UPDATE releases SET notes = '' WHERE notes IS NULL''',
  11: 'ALTER TABLE releases ADD COLUMN modifiedTime DATETIME',
  12: 'UPDATE releases SET modifiedTime = CURRENT_TIMESTAMP WHERE modifiedTime IS NULL',
  13: '''CREATE TABLE releasePictures(
          id INTEGER PRIMARY KEY, 
          filename TEXT,
          pictureType INTEGER
      )''',
  14: 'ALTER TABLE releasePictures ADD COLUMN releaseId INTEGER',
  15: 'ALTER TABLE releasePictures ADD COLUMN createdTime DATETIME',
  16: 'ALTER TABLE releasePictures ADD COLUMN modifiedTime DATETIME',
  17: '''CREATE TABLE releaseProperties(
          id INTEGER PRIMARY KEY,
          releaseId INTEGER,
          propertyType INTEGER,
          createdTime DATETIME,
          modifiedTime DATETIME
     )''',
  18: '''CREATE TABLE movies(
          id INTEGER PRIMARY KEY,
          tmdbId INTEGER,
          title STRING,
          originalTitle STRING,
          overView STRING,
          releaseDate DATETIME,
          createdTime DATETIME,
          updatedTime DATETIME
    )''',
  19: 'ALTER TABLE releases ADD COLUMN movieId INTEGER',
  20: 'ALTER TABLE movies RENAME COLUMN updatedTime TO modifiedTime',
  21: '''CREATE TABLE collectionItems(
          id INTEGER PRIMARY KEY
          releaseId INTEGER NOT NULL
          condition INTEGER
          notes TEXT
          createdTime DATETIME
          modifiedTime DATETIME
          hasSlipCover INTEGER
      )''',
  22: 'ALTER TABLE releases DROP COLUMN condition',
  23: 'ALTER TABLE releases DROP COLUMN hasSlipCover',
};
