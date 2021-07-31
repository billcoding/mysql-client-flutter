import 'package:dart_mysql/dart_mysql.dart';
import 'package:mysql_client_flutter/model/column.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/table.dart';

Future<List<DBTable>> queryTable(
    MySqlConnection mysqlConn, Connection conn) async {
  var results = await mysqlConn.query('''
      select t.TABLE_SCHEMA,
            t.ENGINE,
            t.TABLE_NAME,
            t.TABLE_COMMENT,
            t.ROW_FORMAT,
            t.CREATE_TIME,
            t.TABLE_COLLATION,
            t.CREATE_OPTIONS
      from information_schema.TABLES as t
      where t.TABLE_SCHEMA = ?
      order by t.TABLE_NAME asc
  ''', [conn.database]);
  var tables = <DBTable>[];
  results.forEach((r) {
    tables.add(DBTable(
        schema: r[0],
        engine: r[1],
        name: r[2],
        comment: r[3],
        rowFormat: r[4],
        createTime: r[5],
        collation: r[6],
        createOptions: r[7]));
  });
  return tables;
}

Future<List<Column>> queryColumns(
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
  var columns = <Column>[];
  results.forEach((r) {
    columns.add(Column(
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
