import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/resultset.dart';
import 'package:mysql_client_flutter/pages/results_export.dart';
import 'package:mysql_client_flutter/util/mysql.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';

class QueryPage extends StatefulWidget {
  final Connection conn;
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
  int _resultIndex = 0;

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

  var _resultSet = ResultSet(true, 0, [], []);
  var _gotoController = TextEditingController();
  Widget buildResultItem() {
    var rs = <Widget>[];
    var cs = _resultSet.data[_resultIndex];
    for (var i = 0; i < _resultSet.header.length; i++) {
      rs.add(buildCupertinoFormInfoRow(_resultSet.header[i], cs[i]));
    }
    return ListView(children: [
      CupertinoFormSection(
          header: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            CupertinoIcons.home,
                          ),
                          onPressed: () {
                            setState(() {
                              _resultIndex = 0;
                            });
                          }),
                    ),
                    Expanded(
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(CupertinoIcons.arrow_left),
                          onPressed: () {
                            if (_resultIndex > 0) {
                              setState(() {
                                _resultIndex--;
                              });
                            }
                          }),
                    ),
                    Expanded(
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(CupertinoIcons.arrow_right),
                          onPressed: () {
                            if (_resultIndex < _resultSet.data.length - 1) {
                              setState(() {
                                _resultIndex++;
                              });
                            }
                          }),
                    ),
                    Expanded(
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(CupertinoIcons.forward_end),
                          onPressed: () {
                            setState(() {
                              _resultIndex = _resultSet.data.length - 1;
                            });
                          }),
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        placeholder: '10',
                        controller: _gotoController,
                        keyboardType: TextInputType.number,
                        padding: EdgeInsets.zero,
                        textAlign: TextAlign.center,
                        onEditingComplete: () {
                          if (_gotoController.text == '') {
                            return;
                          }
                          try {
                            var goto = int.parse(_gotoController.text);
                            if (goto >= 1 && goto <= _resultSet.data.length) {
                              setState(() {
                                _resultIndex = goto - 1;
                              });
                            }
                            FocusManager.instance.primaryFocus!.unfocus();
                          } catch (e) {}
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  'Results ${_resultIndex + 1} of ${_resultSet.data.length}',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          children: rs)
    ]);
  }

  Widget buildResults() {
    return _resultSet.data.length == 0
        ? Center(child: Text('No results'))
        : buildResultItem();
  }

  Widget buildMessages() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Text(
          _messages.join('\n'),
          style: TextStyle(fontSize: 16, color: Colors.red),
        ));
  }

  void executeSQL(String sql) async {
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
      var nw = DateTime.now().toString().substring(0, 19);
      addMessage(
          '[$nw]: ' +
              (_resultSet.query
                  ? '${_resultSet.data.length} rows retrieved in $remain ms.'
                  : '${_resultSet.affectedRows} affected rows in $remain ms.'),
          append: true);
      EasyLoading.dismiss();
    } catch (e) {
      addMessage('$e', append: true);
      EasyLoading.showError('$e', duration: Duration(seconds: 1));
    }
  }

  void onPressed(BuildContext context) async {
    switch (_buttonIndex) {
      case 0: // Run
        var sql = _textController.text;
        if (sql == '') return;
        sql.split(';').forEach((sql) {
          executeSQL(sql);
        });
        break;
      case 1: // Done
        FocusManager.instance.primaryFocus!.unfocus();
        setButtonIndex(0);
        break;
      case 2: // Export
        if (_resultSet.query && _resultSet.data.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ResultsExportPage(_resultSet);
          }));
        }
        break;
      case 3: // Clear
        addMessage('');
        break;
    }
  }
}
