class Routine {
  final String name;
  final String schema;
  final String securityType;
  final String createTime;
  final String sqlMode;
  final String definer;
  final String charset;
  final String collation;
  final String definition;
  Routine({
    required this.name,
    required this.schema,
    required this.securityType,
    required this.createTime,
    required this.sqlMode,
    required this.definer,
    required this.charset,
    required this.collation,
    required this.definition,
  });
}
