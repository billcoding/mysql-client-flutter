library mysql_query;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/connection.dart';

class QueryPage extends StatefulWidget {
  final Connection conn;
  QueryPage(this.conn);
  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
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
            'query',
            style: TextStyle(color: Colors.black),
          ),
          trailing: GestureDetector(
              child: Icon(Icons.run_circle), onTap: () async {}),
        ),
        child: SafeArea(child: Text('query')));
  }
}
