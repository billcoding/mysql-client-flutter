class DBTable {
  final String schema;
  final String engine;
  final String name;
  final String comment;
  final String rowFormat;
  final String createTime;
  final String collation;
  final String createOptions;
  DBTable({
    required this.schema,
    required this.engine,
    required this.name,
    required this.comment,
    required this.rowFormat,
    required this.createTime,
    required this.collation,
    required this.createOptions,
  });
}
