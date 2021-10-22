class DBTable {
  /*
   * t.TABLE_CATALOG,
      t.TABLE_SCHEMA,
      t.TABLE_NAME,
      t.TABLE_TYPE,
      t.ENGINE,
      t.VERSION,
      t.ROW_FORMAT,
      t.TABLE_ROWS,
      t.AVG_ROW_LENGTH,
      t.DATA_LENGTH,
      t.MAX_DATA_LENGTH,
      t.INDEX_LENGTH,
      t.DATA_FREE,
      t.AUTO_INCREMENT,
      t.CREATE_TIME,
      t.UPDATE_TIME,
      t.CHECK_TIME,
      t.TABLE_COLLATION,
      t.CHECKSUM,
      t.CREATE_OPTIONS,
      t.TABLE_COMMENT
   */
  final String tableCatalog;
  final String tableSchema;
  final String tableName;
  final String tableType;
  final String tableCollation;
  final String tableComment;
  final String tableRows;
  final String engine;
  final String version;
  final String rowFormat;
  final String avgRowLength;
  final String dataLength;
  final String maxDataLength;
  final String indexLength;
  final String dataFree;
  final String autoIncrement;
  final String createTime;
  final String updateTime;
  final String checkTime;
  final String createOptions;
  DBTable({
    required this.tableCatalog,
    required this.tableSchema,
    required this.tableName,
    required this.tableType,
    required this.tableCollation,
    required this.tableComment,
    required this.tableRows,
    required this.engine,
    required this.version,
    required this.rowFormat,
    required this.avgRowLength,
    required this.dataLength,
    required this.maxDataLength,
    required this.indexLength,
    required this.dataFree,
    required this.autoIncrement,
    required this.createTime,
    required this.updateTime,
    required this.checkTime,
    required this.createOptions,
  });
}
