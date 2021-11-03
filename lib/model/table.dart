class DBTable {
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
  DBTable(
    this.tableCatalog,
    this.tableSchema,
    this.tableName,
    this.tableType,
    this.tableCollation,
    this.tableComment,
    this.tableRows,
    this.engine,
    this.version,
    this.rowFormat,
    this.avgRowLength,
    this.dataLength,
    this.maxDataLength,
    this.indexLength,
    this.dataFree,
    this.autoIncrement,
    this.createTime,
    this.updateTime,
    this.checkTime,
    this.createOptions,
  );
}
