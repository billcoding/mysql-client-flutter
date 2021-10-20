library mysql_main;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/schema.dart';
import 'package:mysql_client_flutter/model/table.dart';
import 'package:mysql_client_flutter/pages/mysql/pages/query.dart';
import 'package:mysql_client_flutter/pages/mysql/pages/table.dart';
import 'package:mysql_client_flutter/util/mysql.dart';

class MainPage extends StatefulWidget {
  final String title;
  final Connection conn;
  MainPage(this.conn, {this.title = ''});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _tabBars = [
    "Schemas",
    "Tables",
    "Routines",
    "Snippets",
    "Files",
  ];
  final _tabBarIcons = <IconData>[
    CupertinoIcons.table,
    CupertinoIcons.table,
    Icons.storage,
    Icons.extension,
    Icons.file_present,
  ];

  List<Schema> _schemas = [];
  List<DBTable> _tables = [];

  @override
  void initState() {
    super.initState();
    open();
    Future.delayed(Duration(milliseconds: 100), () {
      refreshSchemas();
      refreshTables();
    });
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
              child: Icon(CupertinoIcons.settings), onTap: () async {}),
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
      // create Schema tab view
      case 0:
        return buildSchemaTabView(context);
      // create table tab view
      case 1:
        return buildTableTabView(context);
      case 2:
        // create routine tab view
        return buildRoutineTabView(context);
      case 3:
        // create snippet tab view
        return buildSnippetTabView(context);
      case 4:
        // create file tab view
        return buildFileTabView(context);
      default:
        return buildTableTabView(context);
    }
  }

  Widget buildSchemaTabView(BuildContext context) {
    return ListView(children: [
      CupertinoFormSection(
          header: Text('SCHEMAS'), children: buildSchemaItems()),
    ]);
  }

  Widget buildTableTabView(BuildContext context) {
    return ListView(children: [
      CupertinoFormSection(header: Text('ACTIONS'), children: [
        CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                    child: Text(
                      'New query',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return QueryPage(widget.conn);
                        }))),
              )
            ])),
        CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                    child: Text(
                      'New table',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return TablePage(widget.conn);
                        }))),
              )
            ])),
      ]),
      CupertinoFormSection(header: Text('TABLES'), children: buildTableItems()),
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
    var conn = await widget.conn.connect();
    var results = await conn.query('select 1');
    if (results.length > 0) {
      conn.close();
      return;
    }
    EasyLoading.showError('Connect: fail');
    Navigator.pop(context);
  }

  List<Widget> buildSchemaItems() {
    if (_schemas.isEmpty) {
      return [
        CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(children: [
              Expanded(
                  flex: 19,
                  child: Text(
                    'No schema found',
                    style: TextStyle(fontSize: 18),
                  ))
            ]))
      ];
    }
    return _schemas.map((t) {
      return CupertinoFormRow(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(children: [
            Expanded(
                flex: 19,
                child: Text(
                  t.name,
                  style: TextStyle(fontSize: 18),
                ))
          ]));
    }).toList();
  }

  List<Widget> buildTableItems() {
    if (_tables.isEmpty) {
      return [
        CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(children: [
              Expanded(
                  flex: 19,
                  child: Text(
                    'No table found',
                    style: TextStyle(fontSize: 18),
                  ))
            ]))
      ];
    }
    return _tables.map((t) {
      return CupertinoFormRow(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(children: [
            Expanded(
                flex: 19,
                child: Text(
                  t.name,
                  style: TextStyle(fontSize: 18),
                ))
          ]));
    }).toList();
  }

  Future<void> refreshSchemas() async {
    var conn = await widget.conn.connect();
    var schemas = await querySchema(conn, widget.conn);
    _schemas.clear();
    setState(() {
      _schemas.addAll(schemas);
    });
  }

  Future<void> refreshTables() async {
    var conn = await widget.conn.connect();
    var tables = await queryTable(conn, widget.conn);
    _tables.clear();
    setState(() {
      _tables.addAll(tables);
    });
  }
}
