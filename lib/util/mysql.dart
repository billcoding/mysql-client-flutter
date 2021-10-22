import 'package:dart_mysql/dart_mysql.dart';
import 'package:mysql_client_flutter/model/column.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/datatable.dart';
import 'package:mysql_client_flutter/model/schema.dart';
import 'package:mysql_client_flutter/model/table.dart';

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
    print('querySchema schema: $sch');
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
  and t.ENGINE is not null
order by t.TABLE_NAME asc
  ''', [conn.database]);
  var tables = <DBTable>[];
  results.forEach((r) {
    var dbt = DBTable(
      tableCatalog: '${r[0]}',
      tableSchema: '${r[1]}',
      tableName: '${r[2]}',
      tableType: '${r[3]}',
      tableCollation: '${r[4]}',
      tableComment: '${r[5]}',
      tableRows: '${r[6]}',
      engine: '${r[7]}',
      version: '${r[8]}',
      rowFormat: '${r[9]}',
      avgRowLength: '${r[10]}',
      dataLength: '${r[11]}',
      maxDataLength: '${r[12]}',
      indexLength: '${r[13]}',
      dataFree: '${r[14]}',
      autoIncrement: '${r[15]}',
      createTime: '${r[16]}',
      updateTime: '${r[17]}',
      checkTime: '${r[18]}',
      createOptions: '${r[19]}',
    );
    tables.add(dbt);
    print('queryTable table: $dbt');
  });
  return tables;
}

Future<List<DBColumn>> queryColumns(
    MySqlConnection mysqlConn, Connection conn) async {
  var results = await mysqlConn.query('''
select t.TABLE_SCHEMA,
      t.COLLATION_NAME,
      t.CHARACTER_SET_NAME,
      t.TABLE_NAME,
      t.COLUMN_NAME,
      t.ORDINAL_POSITION,
      t.COLUMN_DEFAULT,
      t.DATA_TYPE,
      t.COLUMN_TYPE,
      t.COLUMN_KEY,
      t.EXTRA,
      t.PRIVILEGES,
      t.IS_NULLABLE,
      t.COLUMN_COMMENT
from information_schema.COLUMNS as t
where t.TABLE_SCHEMA = ?
order by t.TABLE_NAME asc, t.ORDINAL_POSITION asc
  ''', [conn.database]);
  var columns = <DBColumn>[];
  results.forEach((r) {
    columns.add(DBColumn(
        schema: r[0],
        collation: r[1],
        charset: r[2],
        table: r[3],
        name: r[4],
        position: r[5],
        defaul: r[6],
        dataType: r[7],
        columnType: r[8],
        key: r[9],
        extra: r[10],
        privilleges: r[11],
        nullable: r[12],
        comment: r[13]));
  });
  return columns;
}

Future<ResultSet> querySql(MySqlConnection conn, String sql) async {
  var results = await conn.query('''
  $sql
  ''');
  var query = results.fields.isNotEmpty;
  var data = <List<String>>[];
  if (query) {
    var row = <String>[];
    results.fields.forEach((e) {
      row.add(e.name!);
    });
    data.add(row);
    results.forEach((e) {
      var row = <String>[];
      for (var item in e) {
        row.add('$item');
      }
      data.add(row);
    });
  }
  return ResultSet(query, query ? 0 : results.affectedRows!, data);
}
