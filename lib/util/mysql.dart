import 'package:dart_mysql/dart_mysql.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/resultset.dart';
import 'package:mysql_client_flutter/model/routine.dart';
import 'package:mysql_client_flutter/model/schema.dart';
import 'package:mysql_client_flutter/model/table.dart';
import 'package:mysql_client_flutter/model/view.dart';

Future<List<Schema>> querySchema(
    MySqlConnection mysqlConn, Connection conn) async {
  var results = await mysqlConn.query('''
select t.SCHEMA_NAME,
       t.DEFAULT_CHARACTER_SET_NAME,
       t.DEFAULT_COLLATION_NAME
from information_schema.SCHEMATA as t
where t.SCHEMA_NAME not in ('information_schema', 'sys', 'mysql', 'performance_schema')
order by (t.SCHEMA_NAME = '${conn.database}') DESC, t.SCHEMA_NAME ASC
  ''');
  var schemas = <Schema>[];
  results.forEach((r) {
    var sch = Schema(r[0], r[1], r[2], r[0] == conn.database);
    schemas.add(sch);
  });
  return schemas;
}

Future<List<DBTable>> queryTable(
    MySqlConnection mysqlConn, Connection conn) async {
  var results = await mysqlConn.query('''
select t.TABLE_CATALOG,
      t.TABLE_SCHEMA,
      t.TABLE_NAME,
      t.TABLE_TYPE,
      t.TABLE_COLLATION,
      t.TABLE_COMMENT,
      t.TABLE_ROWS,
      t.ENGINE,
      t.VERSION,
      t.ROW_FORMAT,
      t.AVG_ROW_LENGTH,
      t.DATA_LENGTH,
      t.MAX_DATA_LENGTH,
      t.INDEX_LENGTH,
      t.DATA_FREE,
      t.AUTO_INCREMENT,
      t.CREATE_TIME,
      t.UPDATE_TIME,
      t.CHECK_TIME,
      t.CREATE_OPTIONS
from information_schema.TABLES as t
where t.TABLE_SCHEMA = ?
  and t.TABLE_TYPE = 'BASE TABLE'
order by t.TABLE_NAME asc
  ''', [conn.database]);
  var tables = <DBTable>[];
  results.forEach((r) {
    var dbt = DBTable(
      '${r[0]}',
      '${r[1]}',
      '${r[2]}',
      '${r[3]}',
      '${r[4]}',
      '${r[5]}',
      '${r[6]}',
      '${r[7]}',
      '${r[8]}',
      '${r[9]}',
      '${r[10]}',
      '${r[11]}',
      '${r[12]}',
      '${r[13]}',
      '${r[14]}',
      '${r[15]}',
      '${r[16]}',
      '${r[17]}',
      '${r[18]}',
      '${r[19]}',
    );
    tables.add(dbt);
  });
  return tables;
}

Future<List<View>> queryView(MySqlConnection mysqlConn, Connection conn) async {
  var results = await mysqlConn.query('''
select t.TABLE_CATALOG,
      t.TABLE_SCHEMA,
      t.TABLE_NAME
from information_schema.TABLES as t
where t.TABLE_SCHEMA = ?
  and t.TABLE_TYPE = 'VIEW'
order by t.TABLE_NAME asc
  ''', [conn.database]);
  var views = <View>[];
  results.forEach((r) {
    var v = View(catalog: '${r[0]}', schema: '${r[1]}', name: '${r[2]}');
    views.add(v);
  });
  return views;
}

Future<List<Routine>> queryRoutine(
    MySqlConnection mysqlConn, Connection conn) async {
  var results = await mysqlConn.query('''
select t.ROUTINE_CATALOG,
       t.ROUTINE_NAME,
       t.ROUTINE_SCHEMA,
       t.SECURITY_TYPE,
       t.CREATED,
       t.SQL_MODE,
       t.DEFINER,
       t.CHARACTER_SET_CLIENT,
       t.DATABASE_COLLATION,
       t.ROUTINE_DEFINITION,
       ifnull(p.ps, '') as ps,
       ifnull(p.p, '') as p
from information_schema.ROUTINES as t
         left join (
    select p.SPECIFIC_NAME,
           group_concat(p.PARAMETER_NAME) as p,
           group_concat(concat(p.PARAMETER_MODE, ' ', p.PARAMETER_NAME, ' ', p.DTD_IDENTIFIER)) as ps
    from information_schema.PARAMETERS as p
    where p.SPECIFIC_SCHEMA = ?
    group by p.SPECIFIC_NAME
) as p on p.SPECIFIC_NAME = t.SPECIFIC_NAME
where t.ROUTINE_SCHEMA = ?
  ''', [conn.database, conn.database]);
  var routines = <Routine>[];
  results.forEach((r) {
    var definer = '${r[6]}';
    definer = definer.replaceFirst("@", "@'") + "'";
    var rt = Routine(
      '${r[0]}',
      '${r[1]}',
      '${r[2]}',
      '${r[3]}',
      '${r[4]}',
      '${r[5]}',
      definer,
      '${r[7]}',
      '${r[8]}',
      '${r[9]}',
      '${r[10]}',
      '${r[11]}',
    );
    routines.add(rt);
  });
  return routines;
}

Future<String> queryTableDDL(
    MySqlConnection mysqlConn, String db, String table) async {
  var results = await mysqlConn.query("""
select *
from (select concat(t.COLUMN_NAME, ' ', t.COLUMN_TYPE, ' ',
                    IF(t.IS_NULLABLE = 'YES', 'NULL ', 'NOT NULL '),
                    if(t.COLUMN_DEFAULT is null, '',
                       concat(' DEFAULT ',
                              case
                                  when t.DATA_TYPE in ('tinyint', 'int', 'bigint', 'float', 'decimal') then t.COLUMN_DEFAULT
                                  when t.DATA_TYPE in ('varchar', 'text', 'longtext')
                                      then concat('\\'', t.COLUMN_DEFAULT, '\\'')
                                  when t.DATA_TYPE in ('datetime', 'date', 'timestamp') then
                                      IF(t.COLUMN_DEFAULT = 'CURRENT_TIMESTAMP',
                                         'CURRENT_TIMESTAMP',
                                         concat('\\'', t.COLUMN_DEFAULT, '\\''))
                                  end, ' ')),
                    t.EXTRA, if(t.EXTRA = '', '', ' '),
                    'COMMENT \\'', t.COLUMN_COMMENT, '\\''
                 ) as c
      from information_schema.COLUMNS as t
      where t.TABLE_SCHEMA = ?
        AND t.TABLE_NAME = ?
      order by t.ORDINAL_POSITION asc) as t
union all
select concat(
               IF(t.INDEX_NAME = 'PRIMARY', 'PRIMARY KEY',
                  concat(if(not t.NON_UNIQUE, 'UNIQUE ', ''), 'INDEX ', t.INDEX_NAME)),
               '(', group_concat(t.COLUMN_NAME), ')'
           )
from information_schema.STATISTICS as t
where t.TABLE_SCHEMA = ?
  AND t.TABLE_NAME = ?
group by t.INDEX_NAME
  """, [db, table, db, table]);
  var defines = [];
  results.forEach((r) {
    defines.add(r[0]);
  });
  var ddlSQL = """CREATE TABLE $table(
        ${defines.join(',\n        ')}
);""";
  return ddlSQL;
}

Future<ResultSet> querySql(Connection _conn, String sql) async {
  var conn = await _conn.connect();
  var results = await conn.query(sql);
  var query = results.fields.isNotEmpty;
  var header = <String>[];
  var data = <List<String>>[];
  if (query) {
    results.fields.forEach((e) {
      header.add(e.name!);
    });
    results.forEach((e) {
      var row = <String>[];
      for (var item in e) {
        row.add('$item');
      }
      data.add(row);
    });
  }
  await conn.close();
  return ResultSet(query, query ? 0 : results.affectedRows!, header, data);
}
