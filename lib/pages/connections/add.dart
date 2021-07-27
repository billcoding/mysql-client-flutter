import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:mysql_client_flutter/util/widget.dart';
import 'package:sp_util/sp_util.dart';

class AddPage extends StatefulWidget {
  final Connection conn;
  final int index;
  AddPage({Key key, this.conn, this.index}) : super(key: key);
  @override
  _AddPageState createState() => _AddPageState(this.conn, this.index);
}

class _AddPageState extends State<AddPage> {
  final Connection conn;
  final int index;
  final bool edit;
  _AddPageState(this.conn, this.index) : edit = conn != null;
  @override
  void initState() {
    super.initState();
    _hostController =
        TextEditingController(text: edit ? conn.host : '192.168.0.252');
    _portController = TextEditingController(text: edit ? conn.port : '3310');
    _userController = TextEditingController(text: edit ? conn.user : 'root');
    _passwordController = TextEditingController(
        text: edit ? conn.password : 'oGMyxw4auP6F6Sn1ENxMVTa1kCc=');
    _databaseController =
        TextEditingController(text: edit ? conn.database : 'test');
    _aliasController =
        TextEditingController(text: edit ? conn.alias : 'connection1');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Connection',
            style: TextStyle(color: Colors.black),
          ),
          trailing: GestureDetector(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () async => save(context),
          ),
        ),
        backgroundColor: Colors.grey[200],
        child: SafeArea(
            child: ListView(
          children: [
            CupertinoFormSection(
              children: [
                buildCupertinoFormSection('CONNECTION', [
                  buildTextField('Host/IP', _hostController),
                  buildTextField('Port', _portController,
                      keyboardType: TextInputType.number),
                  buildTextField('User', _userController),
                  buildTextField('Password', _passwordController,
                      obscureText: true),
                  buildTextField('Datebase', _databaseController),
                ]),
                buildCupertinoFormSection('OTHER', [
                  buildTextField('Alias', _aliasController),
                ]),
                buildCupertinoFormSection('ACTIONS', [
                  CupertinoButton(
                      child: Text('Save'),
                      onPressed: () async => await save(context)),
                  CupertinoButton(
                    child: Text('Test Connection'),
                    onPressed: () async => await test(context),
                  ),
                ]),
              ],
            ),
          ],
        )));
  }

  CupertinoFormSection buildCupertinoFormSection(
      String headerText, List<Widget> children) {
    return CupertinoFormSection(
      header: Text(headerText),
      children: children,
    );
  }

  Widget buildTextField(String text, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            child: Text(text),
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 20),
          ),
        ),
        Expanded(
            flex: 6,
            child: Container(
              child: CupertinoTextField(
                obscureText: obscureText,
                keyboardType: keyboardType,
                textAlign: TextAlign.right,
                controller: controller,
                decoration: null,
              ),
            )),
      ],
    );
  }

  TextEditingController _portController;
  TextEditingController _hostController;
  TextEditingController _userController;
  TextEditingController _passwordController;
  TextEditingController _databaseController;
  TextEditingController _aliasController;

  Future<void> test(BuildContext context) async {
    MySqlConnection.connect(ConnectionSettings(
      host: _hostController.text,
      port: int.parse(_portController.text),
      user: _userController.text,
      db: _databaseController.text,
      password: _passwordController.text,
    )).then((conn) async {
      var results = await conn.query('select "PING OK" as t');
      var nowTime = await results.first['t'];
      showToast(context, 'Server: $nowTime');
    }).onError((error, stackTrace) {
      showToast(context, 'Error: $error');
    });
  }

  Future<void> save(BuildContext context) async {
    String host = _hostController.text;
    String port = _portController.text;
    String user = _userController.text;
    String password = _passwordController.text;
    String database = _databaseController.text;
    String alias = _aliasController.text;
    var conn = Connection(host, port, user, password, database, alias);
    if (SpUtil.containsKey(Keys.connections)) {
      var conns = SpUtil.getObjList(
          Keys.connections, (map) => Connection.fromJson(map));
      if (!edit) {
        conns.add(conn);
      } else {
        conns[index] = conn;
      }
      SpUtil.putObjectList(Keys.connections, conns);
    } else {
      SpUtil.putObjectList(Keys.connections, [conn]);
    }
    showToast(context, 'Save success');
    Timer(Duration(seconds: 1), () => Navigator.of(context).pop());
    conn = null;
  }
}
