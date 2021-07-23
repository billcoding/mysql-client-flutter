import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _portController;
  TextEditingController _hostController;
  TextEditingController _userController;
  TextEditingController _passwordController;
  TextEditingController _databaseController;
  TextEditingController _aliasController;
  @override
  void initState() {
    super.initState();
    _portController = TextEditingController(text: '3306');
    _hostController = TextEditingController(text: '');
    _userController = TextEditingController(text: 'root');
    _passwordController = TextEditingController(text: '');
    _databaseController = TextEditingController(text: '');
    _aliasController = TextEditingController(text: '');
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
            onTap: () {},
          ),
        ),
        backgroundColor: Colors.grey[200],
        child: SafeArea(
          child: CupertinoFormSection(
            children: [
              CupertinoFormSection(
                header: Text('CONNECTION'),
                children: [
                  rowWidget('Host/IP', _hostController),
                  rowWidget('Port', _portController),
                  rowWidget('User', _userController),
                  rowWidget('Password', _passwordController),
                  rowWidget('Datebase', _databaseController),
                ],
              ),
              CupertinoFormSection(
                header: Text('OTHER'),
                children: [
                  rowWidget('Alias', _aliasController),
                ],
              ),
              CupertinoFormSection(header: Text('ACTIONS'), children: [
                CupertinoButton(child: Text('Save'), onPressed: () {}),
                CupertinoButton(
                    child: Text('Test Connection'),
                    onPressed: () async {

                      final conn = await MySqlConnection.connect(
                          ConnectionSettings(
                              host: '192.168.0.252',
                              port: 3310,
                              user: 'root',
                              db: 'test',
                              password: 'oGMyxw4auP6F6Sn1ENxMVTa1kCc='));
                      var results = await conn.query('select now() as t');
                      var nowTime = await results.first['t'];
                      var ft = FToast();
                      ft.init(context);
                      ft.showToast(
                          child: Text('MySQL server now time is $nowTime'));


                    }),
              ]),
            ],
          ),
        ));
  }

  Widget rowWidget(String text, TextEditingController controller) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, top: 12, bottom: 12),
          child: Expanded(
            flex: 2,
            child: Text(text),
          ),
        ),
        Container(
          child: Expanded(
            flex: 6,
            child: Text(''),
          ),
        ),
        Container(
          child: Expanded(
            flex: 2,
            child: CupertinoTextField(
              textAlign: TextAlign.right,
              controller: controller,
              decoration: null,
            ),
          ),
        )
      ],
    );
  }
}
