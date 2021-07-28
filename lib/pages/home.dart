import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/pages/connections/add.dart';
import 'package:mysql_client_flutter/pages/mysql/main.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:mysql_client_flutter/util/ping.dart';
import 'package:sp_util/sp_util.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _pingEnabled = true;
  List<Connection> _connections = <Connection>[];
  List<String> _connectionPings = <String>[];
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () async => refreshConnections());
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
              child: Icon(Icons.refresh_sharp),
              onTap: () async => _pingEnabled ? pingConnection(context) : null),
          trailing: GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () async => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return AddPage();
            })).then((value) async => refreshConnections()),
          ),
        ),
        child: ListView.builder(
          itemCount: _connections.length,
          itemBuilder: (context, index) => buildListViewItem(
              context,
              _connections[index],
              _connectionPings.isEmpty ? '' : _connectionPings[index],
              index),
        ));
  }

  Widget buildListViewItem(
      BuildContext context, Connection conn, String ping, int index) {
    return Container(
        padding: EdgeInsets.only(left: 20, top: 20),
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
            flex: 2,
            child: Text(''),
          ),
          Expanded(
              flex: 1,
              child: Text(
                ping,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.green),
              )),
          Expanded(
            flex: 1,
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.connected_tv_sharp,
              ),
              onPressed: () async => startConnection(
                  context, index), //  async => startConnection(context, index),
            ),
          ),
          Expanded(
            flex: 1,
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.edit,
              ),
              onPressed: () async => editConnection(context, index),
            ),
          ),
          Expanded(
            flex: 1,
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.copy),
              onPressed: () async => copyConnection(context, index),
            ),
          ),
          Expanded(
            flex: 1,
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                CupertinoIcons.delete,
                color: Colors.red,
              ),
              onPressed: () async => removeConnection(context, index),
            ),
          ),
        ]));
  }

  Future<void> refreshConnections() async {
    setState(() {
      var conns = SpUtil.getObjList(
          Keys.connections, (map) => Connection.fromJson(map));
      _connections.clear();
      _connections.addAll(conns);
    });
  }

  Future<void> editConnection(BuildContext context, int index) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddPage(
        conn: _connections[index],
        index: index,
        edit: true,
      );
    })).then((value) => refreshConnections());
  }

  Future<void> copyConnection(BuildContext context, int index) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddPage(conn: _connections[index]);
    })).then((value) => refreshConnections());
  }

  Future<void> removeConnection(BuildContext context, int index) async {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Tips'),
              content: Text('Are you sure to remove this connection?'),
              actions: [
                CupertinoButton(
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      _connections.removeAt(index);
                      SpUtil.putObjectList(Keys.connections, _connections);
                      refreshConnections();
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                    child: Text('No'),
                    onPressed: () async => Navigator.of(context).pop())
              ],
            ));
  }

  Future<void> pingConnection(BuildContext context) async {
    _pingEnabled = false;
    _connectionPings.clear();
    _connections.forEach((conn) {
      _connectionPings.add(ping(conn.host));
    });
    refreshConnections();
    Future.delayed(Duration(seconds: 3), () {
      _connectionPings.clear();
      refreshConnections();
      _pingEnabled = true;
    });
  }

  Future<void> startConnection(BuildContext context, int index) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MainPage(
              title: _connections[index].alias,
            )));
  }
}
