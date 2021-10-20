library mysql_query;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/connection.dart';

class TablePage extends StatefulWidget {
  final Connection conn;
  TablePage(this.conn);
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.grey[200],
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'table',
            style: TextStyle(color: Colors.black),
          ),
          trailing: GestureDetector(
              child: Icon(Icons.run_circle), onTap: () async {}),
        ),
        child: SafeArea(child: Text('table')));
  }
}
