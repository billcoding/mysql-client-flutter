class DBColumn {
  final String schema;
  final String collation;
  final String charset;
  final String table;
  final String name;
  final int position;
  final String defaul;
  final String dataType;
  final String columnType;
  final String key;
  final String extra;
  final String privilleges;
  final String nullable;
  final String comment;
  final String? charactorMaxLength;
  final int? numericPrecision;
  final int? numericScale;
  DBColumn({
    required this.schema,
    required this.collation,
    required this.charset,
    required this.table,
    required this.name,
    required this.position,
    required this.defaul,
    required this.dataType,
    required this.columnType,
    required this.key,
    required this.extra,
    required this.privilleges,
    required this.nullable,
    required this.comment,
    this.charactorMaxLength,
    this.numericPrecision,
    this.numericScale,
  });
}
