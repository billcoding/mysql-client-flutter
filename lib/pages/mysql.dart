import 'package:dart_mysql/dart_mysql.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/routine.dart';
import 'package:mysql_client_flutter/model/schema.dart';
import 'package:mysql_client_flutter/model/snippet.dart';
import 'package:mysql_client_flutter/model/table.dart';
import 'package:mysql_client_flutter/model/view.dart';
import 'package:mysql_client_flutter/pages/query.dart';
import 'package:mysql_client_flutter/pages/routine_info.dart';
import 'package:mysql_client_flutter/pages/schema_info.dart';
import 'package:mysql_client_flutter/pages/table_info.dart';
import 'package:mysql_client_flutter/util/mysql.dart';
import 'package:mysql_client_flutter/util/provider.dart';
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
    "Views",
    "Routines",
    "Snippets",
  ];
  final _tabBarIcons = <IconData>[
    Icons.schema_outlined,
    CupertinoIcons.table,
    CupertinoIcons.table_fill,
    Icons.storage,
    Icons.extension,
  ];

  List<Schema> _schemas = [];
  List<DBTable> _tables = [];
  List<View> _views = [];
  List<Routine> _routines = [];
  List<Snippet> _snippets = [];
  MySqlConnection? _conn;
  CupertinoTabController _tabController = CupertinoTabController();
  String _chooseSchema = '';

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
    await refreshRoutines();
    await refreshViews();
    await refreshSnippets();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
              switch (_tabController.index) {
                case 0:
                  // Refresh schemas
                  refreshSchemas();
                  break;
                case 1:
                  // Refresh tables
                  refreshTables();
                  break;
                case 2:
                  // Refresh Views
                  refreshViews();
                  break;
                case 3:
                  // Refresh routines
                  refreshRoutines();
                  break;
                case 4:
                  // Refresh snippets
                  refreshSnippets();
                  break;
              }
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
          controller: _tabController,
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
        return buildViewTabView(context);
      case 3:
        return buildRoutineTabView(context);
      case 4:
        return buildSnippetTabView(context);
      default:
        return buildSchemaTabView(context);
    }
  }

  Widget buildSchemaTabView(BuildContext context) {
    return ListView(children: [
      CupertinoFormSection(header: Text('ACTIONS'), children: [
        buildCupertinoFormButtonRow(
            'New schema',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QueryPage(widget.conn, 'CREATE DATABASE mydb;');
                }))),
        buildCupertinoFormButtonRow(
            'New query',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QueryPage(widget.conn, '');
                }))),
      ]),
      CupertinoFormSection(
          header: Text('SCHEMAS'),
          children: _schemas.isEmpty
              ? [buildCupertinoFormNoDataRow('No schema found')]
              : _schemas.map((t) {
                  return CupertinoFormRow(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(children: [
                        Expanded(
                          flex: 10,
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
                            flex: 1,
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
                        Expanded(
                            flex: 1,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Text(''),
                            )),
                      ]));
                }).toList()),
    ]);
  }

  Widget buildTableTabView(BuildContext context) {
    return ListView(children: [
      CupertinoFormSection(header: Text('ACTIONS'), children: [
        buildCupertinoFormButtonRow(
            'New table',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QueryPage(widget.conn, """CREATE TABLE mytable(
  id int NOT NULL AUTO_INCREMENT COMMENT '',
  name varchar(50) NOT NULL COMMENT '',
  PRIMARY KEY(id)
)ENGINE=InnoDB COMMENT='mytable';""");
                }))),
        buildCupertinoFormButtonRow(
            'New query',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QueryPage(widget.conn, '');
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

  Widget buildViewTabView(BuildContext context) {
    return ListView(children: [
      CupertinoFormSection(header: Text('ACTIONS'), children: [
        buildCupertinoFormButtonRow(
            'New view',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QueryPage(
                      widget.conn, 'CREATE VIEW vm_now AS SELECT NOW() as t');
                })).then((a) => refreshSnippets())),
        buildCupertinoFormButtonRow(
            'New query',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QueryPage(widget.conn, '');
                }))),
      ]),
      CupertinoFormSection(
          header: Text('VIEWS'),
          children: _views.isEmpty
              ? [buildCupertinoFormNoDataRow('No view found')]
              : _views.map((t) {
                  return CupertinoFormRow(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(children: [
                        Expanded(
                          flex: 10,
                          child: CupertinoButton(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            child: Text(
                              t.name,
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
                              return QueryPage(
                                  widget.conn, 'SELECT * FROM ${t.name};');
                            }));
                          },
                          child: Icon(Icons.search),
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
    return ListView(children: [
      CupertinoFormSection(header: Text('ACTIONS'), children: [
        buildCupertinoFormButtonRow(
            'New routine',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QueryPage(
                      widget.conn, 'CREATE PROCEDURE proc_my() BEGIN END;');
                }))),
        buildCupertinoFormButtonRow(
            'New query',
            () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QueryPage(widget.conn, '');
                }))),
      ]),
      CupertinoFormSection(
          header: Text('ROUTINES'),
          children: _routines.isEmpty
              ? [buildCupertinoFormNoDataRow('No routine found')]
              : _routines.map((r) {
                  return CupertinoFormRow(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(children: [
                        Expanded(
                          flex: 10,
                          child: CupertinoButton(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            child: Text(
                              r.name,
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
                              return RoutineInfoPage(r);
                            }));
                          },
                          child: Icon(Icons.info_outline),
                        )),
                        Expanded(
                            child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return QueryPage(widget.conn, r.callSQL);
                            }));
                          },
                          child: Icon(Icons.play_arrow),
                        )),
                        Expanded(
                            child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return QueryPage(widget.conn, r.definitionSQL);
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
                }).toList())
    ]);
  }

  Widget buildSnippetTabView(BuildContext context) {
    return ListView(children: [
      CupertinoFormSection(
          header: Text('SNIPPETS'),
          children: _snippets.isEmpty
              ? [buildCupertinoFormNoDataRow('No snippet found')]
              : _snippets.map((t) {
                  return CupertinoFormRow(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(children: [
                        Expanded(
                          flex: 10,
                          child: CupertinoButton(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            child: Text(
                              t.alias,
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
                              return QueryPage(widget.conn, t.body);
                            }));
                          },
                          child: Icon(
                            Icons.play_arrow,
                          ),
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

  Future<void> refreshRoutines() async {
    var routines = await queryRoutine(_conn!, widget.conn);
    _routines.clear();
    setState(() {
      _routines.addAll(routines);
    });
  }

  Future<void> refreshViews() async {
    var views = await queryView(_conn!, widget.conn);
    _views.clear();
    setState(() {
      _views.addAll(views);
    });
  }

  Future<void> refreshSnippets() async {
    var snippets = await loadSnippets();
    _snippets.clear();
    setState(() {
      _snippets.addAll(snippets);
    });
  }
}
