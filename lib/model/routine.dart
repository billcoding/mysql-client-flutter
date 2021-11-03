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
  final String parameters;
  final String parameterNames;
  Routine(
    this.catalog,
    this.name,
    this.schema,
    this.securityType,
    this.createTime,
    this.sqlMode,
    this.definer,
    this.charset,
    this.collation,
    this.definition,
    this.parameters,
    this.parameterNames,
  );

  get callSQL => ("""CALL $name($parameterNames);""");
  get definitionSQL => ("""
    CREATE DEFINER = $definer PROCEDURE $name($parameters)
$definition
""");
}
