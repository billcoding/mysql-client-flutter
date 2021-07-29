library mysql_main;

import 'package:flutter/cupertino.dart';
import 'package:dart_mysql/dart_mysql.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client_flutter/model/connection.dart';

class MainPage extends StatefulWidget {
  final String title;
  final Connection conn;
  MainPage(this.conn, {this.title});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MySqlConnection conn;
  final _tabBars = ["Tables", "Routines", "Query", "Files", "Snippets"];
  final _tabBarIcons = <IconData>[
    CupertinoIcons.table,
    Icons.storage,
    Icons.create,
    Icons.file_present,
    Icons.extension,
  ];

  @override
  void initState() {
    super.initState();
    open();
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
        break;
    }
    return null;
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
                  )),
              Expanded(
                  flex: 1,
                  child: Icon(
                    CupertinoIcons.greaterthan,
                    color: Colors.grey,
                  )),
            ])),
        CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(children: [
              Expanded(
                  flex: 19,
                  child: Text(
                    'New table',
                    style: TextStyle(fontSize: 18),
                  )),
              Expanded(
                  flex: 1,
                  child: Icon(
                    CupertinoIcons.greaterthan,
                    color: Colors.grey,
                  )),
            ])),
      ]),
      CupertinoFormSection(header: Text('TABLES'), children: [
        CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(children: [
              Expanded(
                  flex: 19,
                  child: Text(
                    'New query',
                    style: TextStyle(fontSize: 18),
                  )),
              Expanded(
                  flex: 1,
                  child: Icon(
                    CupertinoIcons.greaterthan,
                    color: Colors.grey,
                  )),
            ])),
        CupertinoFormRow(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(children: [
              Expanded(
                  flex: 19,
                  child: Text(
                    'New table',
                    style: TextStyle(fontSize: 18),
                  )),
              Expanded(
                  flex: 1,
                  child: Icon(
                    CupertinoIcons.greaterthan,
                    color: Colors.grey,
                  )),
            ])),
      ]),
    ]);
  }

  Future<void> open() async {
    var conn = await widget.conn.connect();
    if (conn != null) {
      var results = await conn.query('select 1');
      if (results.length > 0) {
        this.conn = conn;
        return;
      }
    }
    EasyLoading.showError('connect: fail');
    Navigator.of(context).pop();
  }
}
