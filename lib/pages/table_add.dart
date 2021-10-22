import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/connection.dart';

class TableAddPage extends StatefulWidget {
  final Connection conn;
  TableAddPage(this.conn);
  @override
  _TableAddPageState createState() => _TableAddPageState();
}

class _TableAddPageState extends State<TableAddPage> {
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
