class Routine {
  final String catalog;
  final String name;
  final String schema;
  final String securityType;
  final String createTime;
  final String sqlMode;
  final String definer;
  final String charset;
  final String collation;
  final String definition;
  final String comment;
  final String parameters;
  final String parameterNames;
  Routine({
    required this.catalog,
    required this.name,
    required this.schema,
    required this.securityType,
    required this.createTime,
    required this.sqlMode,
    required this.definer,
    required this.charset,
    required this.collation,
    required this.definition,
    required this.comment,
    required this.parameters,
    required this.parameterNames,
  });

  get callSQL => ("""CALL $name($parameterNames);""");
  get definitionSQL => ("""
    CREATE DEFINER = $definer PROCEDURE $name($parameters)
COMMENT '$comment'
$definition
""");
}
