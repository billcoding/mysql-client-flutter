library mysql_main;

import 'package:dart_mysql/dart_mysql.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/table.dart';
import 'package:mysql_client_flutter/util/mysql.dart';

class MainPage extends StatefulWidget {
  final String title;
  final Connection conn;
  MainPage(this.conn, {this.title = ''});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MySqlConnection conn;
  final _tabBars = ["Tables", "Routines", "Query", "Files", "Snippets"];
  final _tabBarIcons = <IconData>[
    CupertinoIcons.table,
    Icons.storage,
    Icons.create,
    Icons.file_present,
    Icons.extension,
  ];

  int queryMaxLines = 28;
  List<DBTable> _tables = [];

  @override
  void initState() {
    super.initState();
    open();
    refreshTables();
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
      // create table tab view
      case 0:
        return buildTableTabView(context);
      case 1:
        // create routine tab view
        return buildRoutineTabView(context);
      case 2:
        // create query tab view
        return buildQueryTabView(context);
      case 3:
        // create file tab view
        return buildFileTabView(context);
      case 4:
        // create snippet tab view
        return buildSnippetTabView(context);
      default:
        return buildTableTabView(context);
    }
  }

  Widget buildTableTabView(BuildContext context) {
    return Column(children: [
      CupertinoFormSection(header: Text('ACTIONS'), children: [
        CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(children: [
              Expanded(
                  flex: 19,
                  child: Text(
                    'New query',
                    style: TextStyle(fontSize: 18),
                  ))
            ])),
        CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(children: [
              Expanded(
                  flex: 19,
                  child: Text(
                    'New table',
                    style: TextStyle(fontSize: 18),
                  ))
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

  Widget buildQueryTabView(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CupertinoButton(
                child: Text('OK'),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setQueryMaxline(28);
                }),
            CupertinoButton(child: Text('Execute'), onPressed: () async => {}),
            CupertinoButton(child: Text('Save'), onPressed: () async => {}),
          ],
        ),
        Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 60),
            child: CupertinoTextField(
              onTap: () async => setQueryMaxline(14),
              maxLines: queryMaxLines,
            ))
      ],
    );
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

  void setQueryMaxline(int maxLines) => setState(() {
        queryMaxLines = maxLines;
      });

  List<Widget> buildTableItems() {
    return _tables
        .map((t) => CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            prefix: Text(
              t.name,
              style: TextStyle(fontSize: 18),
            ),
            child: Text('')))
        .toList();
  }

  Future<void> open() async {
    var conn = await widget.conn.connect();
    var results = await conn.query('select 1');
    if (results.length > 0) {
      this.conn = conn;
      return;
    }
    EasyLoading.showError('connect: fail');
    Navigator.of(context).pop();
  }

  Future<void> refreshTables() async {
    setState(() async {
      _tables = (await queryTable(conn, widget.conn));
    });
  }
}
