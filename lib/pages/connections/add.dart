import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:mysql_client_flutter/util/toast.dart';
import 'package:sp_util/sp_util.dart';

class AddPage extends StatefulWidget {
  final Connection conn;
  final int index;
  final bool edit;
  AddPage({Key key, this.conn, this.index, this.edit = false})
      : super(key: key);
  @override
  _AddPageState createState() =>
      _AddPageState(this.conn, this.index, this.edit);
}

class _AddPageState extends State<AddPage> {
  final Connection conn;
  final int index;
  final bool edit;
  TextEditingController _portController;
  TextEditingController _hostController;
  TextEditingController _userController;
  TextEditingController _passwordController;
  TextEditingController _databaseController;
  TextEditingController _aliasController;
  ScrollController _scrollController;
  bool _saveEnabled = true;
  bool _testEnabled = true;
  GlobalKey<FormState> _formKey = GlobalKey();

  _AddPageState(this.conn, this.index, this.edit);

  @override
  void initState() {
    super.initState();
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
            'Connection',
            style: TextStyle(color: Colors.black),
          ),
          trailing: GestureDetector(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () async => _saveEnabled ? save(context) : null,
          ),
        ),
        backgroundColor: Colors.grey[200],
        child: SafeArea(
            child: ListView(controller: _scrollController, children: [
          Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              onChanged: () {
                Form.of(primaryFocus.context).save();
              },
              child: CupertinoFormSection(children: [
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
                  buildTextField('Datebase', _databaseController,
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

  Widget buildTextField(String text, TextEditingController controller,
      {bool password = false,
      TextInputType keyboardType = TextInputType.text,
      int maxLength = 50,
      String placeholder}) {
    return CupertinoTextFormFieldRow(
      prefix: Text(text),
      obscureText: password,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      controller: controller,
      maxLength: maxLength,
      maxLines: 1,
      decoration: null,
      placeholder: placeholder,
      validator: (String value) {
        return value.isEmpty ? 'Please enter this field.' : null;
      },
    );
  }

  Future<void> test(BuildContext context) async {
    _testEnabled = false;
    if (!_formKey.currentState.validate()) {
      _testEnabled = true;
      return;
    }
    MySqlConnection.connect(ConnectionSettings(
      host: _hostController.text,
      port: int.parse(_portController.text),
      user: _userController.text,
      db: _databaseController.text,
      password: _passwordController.text,
      timeout: Duration(seconds: 1),
    )).then((conn) async {
      var results = await conn.query('select "PING OK" as t');
      var nowTime = await results.first['t'];
      showToast(context, 'Server: $nowTime');
      _testEnabled = true;
    }).onError((error, stackTrace) {
      showToast(context, 'Error: fail');
      _testEnabled = true;
    });
  }

  Future<void> save(BuildContext context) async {
    _saveEnabled = false;
    if (!_formKey.currentState.validate()) {
      _saveEnabled = true;
      return;
    }
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
      if (edit) {
        // edit
        conns[index] = conn;
      } else {
        conns.add(conn);
      }
      SpUtil.putObjectList(Keys.connections, conns);
    } else {
      SpUtil.putObjectList(Keys.connections, [conn]);
    }
    showToast(context, 'Save success');
    _saveEnabled = true;
    Navigator.of(context).pop();
  }
}
