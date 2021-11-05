import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/snippet.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:mysql_client_flutter/util/toast.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';
import 'package:sp_util/sp_util.dart';

class DataImportPage extends StatefulWidget {
  const DataImportPage({Key? key}) : super(key: key);
  @override
  _DataImportPageState createState() => _DataImportPageState();
}

class _DataImportPageState extends State<DataImportPage> {
  @override
  void initState() {
    super.initState();
  }

  List<String> _dataTypes = ['Connections', 'Snippets', 'Flush'];

  int _i = -1;
  int _index = 0;
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    _i = -1;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Import'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Browse'),
          onPressed: () async {
            var fr = await FilePicker.platform.pickFiles(
                dialogTitle: 'Choose import file',
                type: FileType.custom,
                allowedExtensions: ['json']);
            if (fr == null || fr.count <= 0) {
              return;
            }
            EasyLoading.show(status: 'Loading');
            try {
              var f = File(fr.files[0].path!);
              if (await f.exists()) {
                var json = await f.readAsString();
                switch (_index) {
                  case 0:
                    // Connection
                    importConnections(json);
                    break;
                  case 1:
                    // Snippet
                    importSnippets(json);
                    break;
                }
              }
            } catch (e) {
              EasyLoading.showError('Import error',
                  duration: Duration(seconds: 1));
            }
            EasyLoading.dismiss();
          },
        ),
      ),
      child: SafeArea(
          child: ListView(
        children: [
          CupertinoFormSection(
              header: Text('IMPORT TYPE'),
              children:
                  _dataTypes.map((s) => buildChoiceItem(s, ++_i)).toList()),
        ],
      )),
    );
  }

  Widget buildChoiceItem(String text, int index) {
    return index == 2
        ? buildCupertinoStdRow(
            'Flush',
            Container(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerRight,
              child: CupertinoSwitch(
                  value: switchValue,
                  onChanged: (value) async {
                    setState(() {
                      switchValue = value;
                    });
                  }),
            ),
            verticalPad: false,
          )
        : CupertinoFormRow(
            padding: EdgeInsets.only(left: 20),
            child: Row(children: [
              Expanded(
                flex: 4,
                child: CupertinoButton(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  pressedOpacity: 1.0,
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  onPressed: () {
                    setState(() {
                      _index = index;
                    });
                  },
                ),
              ),
              Expanded(
                  child: _index == index
                      ? CupertinoButton(
                          padding: EdgeInsets.zero,
                          pressedOpacity: 1.0,
                          onPressed: () {},
                          child: Icon(
                            Icons.check_outlined,
                          ),
                        )
                      : CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(''),
                          onPressed: () async {
                            setState(() {
                              _index = index;
                            });
                          })),
            ]));
  }

  void importConnections(String json) async {
    var connections = <Connection>[];
    (jsonDecode(json) as List).forEach((l) {
      try {
        connections.add(Connection.fromJson(l));
      } catch (e) {}
    });
    if (connections.length > 0) {
      if (switchValue) {
        SpUtil.putObjectList(Keys.connections, connections);
      } else {
        var conns = SpUtil.getObjList(
            Keys.connections, (map) => Connection.fromJson(map));
        if (conns != null) {
          conns.addAll(connections);
          SpUtil.putObjectList(Keys.connections, conns);
        }
      }
      showToast(context, 'Imported ${connections.length} connections.');
    } else {
      showToast(context, 'Invalid data.');
    }
  }

  void importSnippets(String json) async {
    var snippets = <Snippet>[];
    (jsonDecode(json) as List).forEach((l) {
      try {
        snippets.add(Snippet.fromJson(l));
      } catch (e) {}
    });
    if (snippets.length > 0) {
      if (switchValue) {
        SpUtil.putObjectList(Keys.snippets, snippets);
      } else {
        var ss =
            SpUtil.getObjList(Keys.snippets, (map) => Snippet.fromJson(map));
        if (ss != null) {
          ss.addAll(snippets);
          SpUtil.putObjectList(Keys.snippets, ss);
        }
      }
      showToast(context, 'Imported ${snippets.length} snippets.');
    } else {
      showToast(context, 'Invalid data.');
    }
  }
}
