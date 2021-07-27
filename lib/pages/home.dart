import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/pages/connections/add.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:sp_util/sp_util.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      refreshConnections();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey[200],
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'MySQL Client',
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          child: Icon(Icons.refresh),
          onTap: () async => this.initState(),
        ),
        trailing: GestureDetector(
          child: Icon(Icons.add),
          onTap: () async =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddPage();
          })).then((value) async => refreshConnections()),
        ),
      ),
      child: ListView.builder(
        itemCount: _connections.length,
        itemBuilder: (context, index) =>
            buildListViewItem(context, _connections[index], index),
      ),
    );
  }

  Widget buildListViewItem(BuildContext context, Connection conn, int index) {
    return Container(
        padding: EdgeInsets.only(left: 20, top: 10),
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Container(
                  child: Image(
                image: AssetImage('assets/images/mysql.png'),
                fit: BoxFit.fill,
              ))),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${conn.alias}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${conn.host}',
                  ),
                ],
              )),
          Expanded(
            flex: 3,
            child: Text(''),
          ),
          Expanded(
            flex: 1,
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.edit,
                size: 30,
              ),
              onPressed: () async => editConnection(context, index),
            ),
          ),
          Expanded(
            flex: 1,
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.delete,
                size: 30,
                color: Colors.redAccent,
              ),
              onPressed: () async => removeConnection(context, index),
            ),
          ),
        ]));
  }

  List<Connection> _connections = <Connection>[];

  Future<void> refreshConnections() async {
    setState(() {
      var conns = SpUtil.getObjList(
          Keys.connections, (map) => Connection.fromJson(map));
      _connections.clear();
      _connections.addAll(conns);
    });
  }

  Future editConnection(BuildContext context, int index) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddPage(conn: _connections[index]);
    }));
  }

  Future removeConnection(BuildContext context, int index) async {
    _connections.removeAt(index);
    SpUtil.putObjectList(Keys.connections, _connections);
    refreshConnections();
  }
}
