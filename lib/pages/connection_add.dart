import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:mysql_client_flutter/util/toast.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';
import 'package:sp_util/sp_util.dart';

class ConnectionAddPage extends StatefulWidget {
  final Connection? conn;
  final int index;
  final bool edit;
  ConnectionAddPage({Key? key, this.conn, this.index = 0, this.edit = false})
      : super(key: key);
  @override
  _ConnectionAddPageState createState() => _ConnectionAddPageState();
}

class _ConnectionAddPageState extends State<ConnectionAddPage> {
  late TextEditingController _portController;
  late TextEditingController _hostController;
  late TextEditingController _userController;
  late TextEditingController _passwordController;
  late TextEditingController _databaseController;
  late TextEditingController _aliasController;
  bool _saveEnabled = true;
  bool _testEnabled = true;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    var conn = widget.conn;
    _hostController = TextEditingController(text: conn?.host);
    _portController = TextEditingController(text: conn?.port);
    _userController = TextEditingController(text: conn?.user);
    _passwordController = TextEditingController(text: conn?.password);
    _databaseController = TextEditingController(text: conn?.database);
    _aliasController = TextEditingController(text: conn?.alias);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            widget.edit
                ? 'edit: ${widget.conn!.alias}'
                : 'add' +
                    (widget.conn != null
                        ? (': copy from ' + widget.conn!.alias)
                        : ''),
            style: TextStyle(color: Colors.black),
          ),
          trailing: null,
        ),
        child: SafeArea(
            child: ListView(children: [
          Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: [
                buildCupertinoFormSection('CONNECTION', [
                  buildTextField('Host/IP', _hostController,
                      placeholder: "localhost"),
                  buildTextField('Port', _portController,
                      keyboardType: TextInputType.number,
                      placeholder: "3306",
                      maxLength: 5),
                  buildTextField('User', _userController, placeholder: "root"),
                  buildTextField('Password', _passwordController,
                      password: true, placeholder: "password"),
                  buildTextField('Database', _databaseController,
                      placeholder: "test"),
                ]),
                buildCupertinoFormSection('OTHER', [
                  buildTextField('Alias', _aliasController,
                      placeholder: "some-connection", maxLength: 20),
                ]),
                buildCupertinoFormSection('ACTIONS', [
                  CupertinoButton(
                      child: Text('Save'),
                      onPressed: () async => await Future.value(
                          _saveEnabled ? save(context) : null)),
                  CupertinoButton(
                    child: Text('Test Connection'),
                    onPressed: () async =>
                        await Future.value(_testEnabled ? test(context) : null),
                  ),
                ]),
              ]))
        ])));
  }

  CupertinoFormSection buildCupertinoFormSection(
      String headerText, List<Widget> children) {
    return CupertinoFormSection(
      header: Text(headerText),
      children: children,
    );
  }

  Future<void> test(BuildContext context) async {
    _testEnabled = false;
    var validated = _formKey.currentState?.validate();
    if (validated == false) {
      _testEnabled = true;
      return;
    }
    createConnection().connect().then((conn) async {
      var results = await conn.query('select "success" as t');
      var nowTime = await results.first['t'];
      showToast(context, 'Ping: $nowTime');
      _testEnabled = true;
    }).onError((error, stackTrace) {
      showToast(context, 'Ping: $error');
      _testEnabled = true;
    });
  }

  Future<void> save(BuildContext context) async {
    _saveEnabled = false;
    var validated = _formKey.currentState?.validate();
    if (validated == false) {
      _saveEnabled = true;
      return;
    }
    var conn = createConnection();
    if (SpUtil.containsKey(Keys.connections) ?? false) {
      var conns = SpUtil.getObjList(
              Keys.connections, (map) => Connection.fromJson(map)) ??
          [];
      if (widget.edit) {
        // edit
        conns[widget.index] = conn;
      } else {
        conns.add(conn);
      }
      SpUtil.putObjectList(Keys.connections, conns);
    } else {
      SpUtil.putObjectList(Keys.connections, [conn]);
    }
    showToast(context, 'Save success');
    _saveEnabled = true;
    Navigator.pop(context);
  }

  Connection createConnection() {
    String host = _hostController.text;
    String port = _portController.text;
    String user = _userController.text;
    String password = _passwordController.text;
    String database = _databaseController.text;
    String alias = _aliasController.text;
    return Connection(host, port, user, password, database, alias);
  }
}
