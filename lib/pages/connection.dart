import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/pages/connection_add.dart';
import 'package:mysql_client_flutter/pages/mysql.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:sp_util/sp_util.dart';

class ConnectionPage extends StatefulWidget {
  ConnectionPage({
    Key? key,
  }) : super(key: key);
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  List<Connection> _connections = <Connection>[];
  List<String> _connectionPings = <String>[];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1), () async => refresh());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.grey[200],
        navigationBar: CupertinoNavigationBar(
          middle: Text('Connections', style: TextStyle(color: Colors.black)),
          leading: GestureDetector(
              child: Icon(Icons.settings_outlined), onTap: () async {}),
          trailing: GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () async => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return ConnectionAddPage();
            })).then((value) async => refresh()),
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
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${conn.alias}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${conn.host}',
                  ),
                ],
              )),
          Expanded(
              flex: 2,
              child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    ping,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: Colors.green),
                  ))),
          Expanded(
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.connected_tv_sharp,
              ),
              onPressed: () async => start(context, index),
            ),
          ),
          Expanded(
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.edit,
              ),
              onPressed: () async => edit(context, index),
            ),
          ),
          Expanded(
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.copy),
              onPressed: () async => copy(context, index),
            ),
          ),
          Expanded(
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                CupertinoIcons.delete,
                color: Colors.red,
              ),
              onPressed: () async => remove(context, index),
            ),
          ),
        ]));
  }

  Future<void> refresh() async {
    setState(() {
      var conns = SpUtil.getObjList(
          Keys.connections, (map) => Connection.fromJson(map));
      if (conns != null) {
        _connections.clear();
        _connections.addAll(conns);
      }
    });
  }

  Future<void> edit(BuildContext context, int index) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ConnectionAddPage(
        conn: _connections[index],
        index: index,
        edit: true,
      );
    })).then((value) => refresh());
  }

  Future<void> copy(BuildContext context, int index) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ConnectionAddPage(conn: _connections[index]);
    })).then((value) => refresh());
  }

  Future<void> remove(BuildContext context, int index) async {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                'Are you sure to remove this connection?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text('This operation is not be restored!'),
              actions: [
                CupertinoButton(
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      _connections.removeAt(index);
                      SpUtil.putObjectList(Keys.connections, _connections);
                      refresh();
                      Navigator.pop(context);
                    }),
                CupertinoButton(
                    child: Text('No',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async => Navigator.pop(context))
              ],
            ));
  }

  Future<void> start(BuildContext context, int index) async {
    EasyLoading.show(status: 'Connecting...');
    var _conn = _connections[index];
    _conn.connect().then((conn) async {
      conn.close();
      EasyLoading.dismiss();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MySqlPage(_conn, title: _conn.alias)));
    }).onError((error, stackTrace) {
      EasyLoading.showError('Connect: $error');
    });
  }
}
