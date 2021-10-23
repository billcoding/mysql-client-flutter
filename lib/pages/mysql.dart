import 'package:dart_mysql/dart_mysql.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/schema.dart';
import 'package:mysql_client_flutter/model/table.dart';
import 'package:mysql_client_flutter/pages/query.dart';
import 'package:mysql_client_flutter/pages/schema_info.dart';
import 'package:mysql_client_flutter/pages/table_add.dart';
import 'package:mysql_client_flutter/pages/table_info.dart';
import 'package:mysql_client_flutter/util/mysql.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';

class MySqlPage extends StatefulWidget {
  final String title;
  final Connection conn;
  MySqlPage(this.conn, {this.title = ''});
  @override
  _MySqlPageState createState() => _MySqlPageState();
}

class _MySqlPageState extends State<MySqlPage> {
  final _tabBars = [
    "Schemas",
    "Tables",
    "Routines",
    "Snippets",
    "Files",
  ];
  final _tabBarIcons = <IconData>[
    Icons.schema_outlined,
    CupertinoIcons.table,
    Icons.storage,
    Icons.extension,
    Icons.file_present,
  ];

  List<Schema> _schemas = [];
  List<DBTable> _tables = [];
  MySqlConnection? _conn;

  @override
  void initState() {
    super.initState();
    refreshAll('');
  }

  Future<void> refreshAll(String db) async {
    if (db != '' && db != widget.conn.database) {
      widget.conn.database = db;
    }
    await open();
    await refreshSchemas();
    await refreshTables();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.grey[200],
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            widget.title,
            style: TextStyle(color: Colors.black),
          ),
          trailing: GestureDetector(
            child: Icon(Icons.refresh),
            onTap: () async {
              await EasyLoading.show(
                  status: 'Refreshing...', dismissOnTap: true);
              await refreshAll('');
              await EasyLoading.dismiss();
            },
          ),
        ),
        child: SafeArea(
            child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: buildTabBar(),
          ),
          tabBuilder: buildTab,
        )));
  }

  List<BottomNavigationBarItem> buildTabBar() {
    return List.generate(
      _tabBars.length,
      (index) => BottomNavigationBarItem(
          icon: Icon(_tabBarIcons[index]), label: _tabBars[index]),
    );
  }

  Widget buildTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        return buildSchemaTabView(context);
      case 1:
        return buildTableTabView(context);
      case 2:
        return buildRoutineTabView(context);
      case 3:
        return buildSnippetTabView(context);
      case 4:
        return buildFileTabView(context);
      default:
        return buildSchemaTabView(context);
    }
  }

  Widget buildSchemaTabView(BuildContext context) {
    return ListView(children: [
      CupertinoFormSection(
          header: Text('SCHEMAS'),
          children: _schemas.isEmpty
              ? [buildCupertinoFormNoDataRow('No schema found')]
              : _schemas.map((t) {
                  return CupertinoFormRow(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(children: [
                        Expanded(
                          flex: 7,
                          child: CupertinoButton(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            child: Text(
                              t.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: t.choose
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: Colors.black),
                            ),
                            onPressed: () => refreshAll(t.name),
                          ),
                        ),
                        Expanded(
                            child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return SchemaInfoPage(t);
                            }));
                          },
                          child: Icon(
                            Icons.info_outline,
                          ),
                        )),
                      ]));
                }).toList()),
    ]);
  }

  Widget buildTableTabView(BuildContext context) {
    return ListView(children: [
      CupertinoFormSection(header: Text('ACTIONS'), children: [
        buildCupertinoFormButtonRow(
            'New query',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QueryPage(widget.conn, '');
                }))),
        buildCupertinoFormButtonRow(
            'New table',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TableAddPage(widget.conn);
                }))),
      ]),
      CupertinoFormSection(
          header: Text('TABLES'),
          children: _tables.isEmpty
              ? [buildCupertinoFormNoDataRow('No table found')]
              : _tables.map((t) {
                  return CupertinoFormRow(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(children: [
                        Expanded(
                          flex: 10,
                          child: CupertinoButton(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            child: Text(
                              t.tableName,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () => {},
                          ),
                        ),
                        Expanded(
                            child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return TableInfoPage(t);
                            }));
                          },
                          child: Icon(
                            Icons.info_outline,
                          ),
                        )),
                        Expanded(
                            child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return QueryPage(widget.conn,
                                  'SELECT t.* FROM ${t.tableName} AS t LIMIT 0, 100');
                            }));
                          },
                          child: Icon(
                            Icons.search,
                          ),
                        )),
                        Expanded(
                            child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            var ddlSQL = await queryTableDDL(
                                _conn!, _chooseSchema, t.tableName);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return QueryPage(widget.conn, '$ddlSQL');
                            }));
                          },
                          child: Icon(Icons.copy),
                        )),
                        Expanded(
                            child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Text(''),
                        )),
                      ]));
                }).toList()),
    ]);
  }

  Widget buildRoutineTabView(BuildContext context) {
    return CupertinoFormSection(header: Text('ROUTINES'), children: [
      CupertinoFormRow(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        prefix: Text(
          'proc_helloworld',
          style: TextStyle(fontSize: 18),
        ),
        child: Text(''),
      ),
    ]);
  }

  Widget buildFileTabView(BuildContext context) {
    return Column(children: [
      CupertinoFormSection(header: Text('FILES'), children: [
        CupertinoFormRow(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          prefix: Text(
            'file.sql',
            style: TextStyle(fontSize: 18),
          ),
          child: Text(''),
        ),
      ]),
    ]);
  }

  Widget buildSnippetTabView(BuildContext context) {
    return Column(children: [
      CupertinoFormSection(header: Text('SNIPPETS'), children: [
        CupertinoFormRow(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          prefix: Text(
            'select_table_person',
            style: TextStyle(fontSize: 18),
          ),
          child: Text(''),
        ),
      ]),
    ]);
  }

  Future<void> open() async {
    try {
      await _conn!.close();
    } catch (e) {}
    var conn = await widget.conn.connect();
    var results = await conn.query('select 1');
    if (results.length > 0) {
      _conn = conn;
      return;
    }
    EasyLoading.showError('Connect: fail');
    Navigator.pop(context);
  }

  String _chooseSchema = '';
  Future<void> refreshSchemas() async {
    var schemas = await querySchema(_conn!, widget.conn);
    for (var i = 0; i < schemas.length; i++) {
      var e = schemas[i];
      if (e.choose) {
        _chooseSchema = e.name;
        break;
      }
    }
    _schemas.clear();
    setState(() {
      _schemas.addAll(schemas);
    });
  }

  Future<void> refreshTables() async {
    var tables = await queryTable(_conn!, widget.conn);
    _tables.clear();
    setState(() {
      _tables.addAll(tables);
    });
  }
}
