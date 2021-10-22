import 'dart:io';

import 'package:dart_mysql/dart_mysql.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client_flutter/model/datatable.dart';
import 'package:mysql_client_flutter/util/mysql.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class QueryPage extends StatefulWidget {
  final MySqlConnection conn;
  final String sql;
  QueryPage(this.conn, this.sql);
  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  List<String> _messages = [];
  TextEditingController _textController = TextEditingController();
  final _tabBars = [
    'Editor',
    'Results',
    'Messages',
  ];
  final _tabBarIcons = <IconData>[
    Icons.edit,
    CupertinoIcons.table,
    Icons.message,
  ];
  int _buttonIndex = 0;
  final _buttons = ['Run', 'Done', 'Export', 'Clear'];

  void setButtonIndex(int index) {
    setState(() {
      _buttonIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _textController.text = widget.sql;
  }

  void addMessage(String message, {bool append = false}) {
    setState(() {
      if (!append) {
        _messages.clear();
      }
      if (message != '') {
        _messages.add(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.grey[200],
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Query',
            style: TextStyle(color: Colors.black),
          ),
          trailing: CupertinoButton(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.zero,
              child: Text(_buttons[_buttonIndex]),
              onPressed: () => onPressed(context)),
        ),
        child: SafeArea(
            child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            onTap: (index) => setButtonIndex(index == 0 ? 0 : index + 1),
            items: List.generate(
              _tabBars.length,
              (index) => BottomNavigationBarItem(
                  icon: Icon(_tabBarIcons[index]), label: _tabBars[index]),
            ),
          ),
          tabBuilder: buildTab,
        )));
  }

  Widget buildTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        return buildEditor();
      case 1:
        return buildResults();
      case 2:
        return buildMessages();
      default:
        return buildEditor();
    }
  }

  Widget buildEditor() {
    return Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            CupertinoTextField(
              controller: _textController,
              maxLines: 31,
              onTap: () => setButtonIndex(1),
            )
          ],
        ));
  }

  Widget buildTableCell(String text, {textAlign: TextAlign.center}) {
    return TableCell(
        child: Text(
      text,
      textAlign: textAlign,
    ));
  }

  var _resultSet = ResultSet(true, 0, []);

  Widget buildResults() {
    return ListView(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 60),
        children: [
          Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: Colors.blue),
              children: _resultSet.data.map((r) {
                return TableRow(
                    children: r.map((c) {
                  return buildTableCell('$c');
                }).toList());
              }).toList())
        ]);
  }

  Widget buildMessages() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Text(
          _messages.join('\n'),
          style: TextStyle(fontSize: 14),
        ));
  }

  void onPressed(BuildContext context) async {
    switch (_buttonIndex) {
      case 0: // Run
        var sql = _textController.text;
        if (sql == '') return;
        try {
          EasyLoading.show(
            status: 'Executing...',
          );
          int start = DateTime.now().millisecondsSinceEpoch;
          var rs = await querySql(widget.conn, sql);
          setState(() {
            _resultSet = rs;
          });
          int end = DateTime.now().millisecondsSinceEpoch;
          var remain = end - start;
          addMessage(
              _resultSet.query
                  ? '${DateTime.now()}: ${_resultSet.data.length - 1} rows retrieved in $remain ms.'
                  : '${DateTime.now()}: ${_resultSet.affectedRows} affected rows in $remain ms.',
              append: true);
          EasyLoading.dismiss();
        } catch (e) {
          addMessage('$e', append: true);
          EasyLoading.showError('$e', duration: Duration(seconds: 1));
        }
        break;
      case 1: // Done
        FocusManager.instance.primaryFocus!.unfocus();
        setButtonIndex(0);
        break;
      case 2: // Export
        if (_resultSet.query && _resultSet.data.isNotEmpty) {
          var excel = Excel.createExcel();
          var sheet = excel.sheets['Sheet1'];
          _resultSet.data.forEach((e) {
            sheet!.appendRow(e);
          });
          var docDir = await getApplicationDocumentsDirectory();
          var bytes = excel.save();
          var f = File("${docDir.path}/query_output.xlsx")
            ..create(recursive: true)
            ..writeAsBytes(bytes!);
          await Share.shareFiles([f.path]);
        }
        break;
      case 3: // Clear
        addMessage('');
        break;
    }
  }
}
