Map<int, String> migrationScripts = {
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
};
