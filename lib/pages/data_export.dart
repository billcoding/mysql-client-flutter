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
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sp_util/sp_util.dart';

class DataExportPage extends StatefulWidget {
  const DataExportPage({Key? key}) : super(key: key);
  @override
  _DataExportPageState createState() => _DataExportPageState();
}

class _DataExportPageState extends State<DataExportPage> {
  @override
  void initState() {
    super.initState();
  }

  List<String> _dataTypes = ['Connections', 'Snippets'];

  int _i = -1;
  int _index = 0;
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    _i = -1;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Export'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Save'),
          onPressed: () async {
            var docDir = await getApplicationDocumentsDirectory();
            var json = '';
            var fileName = '';
            switch (_index) {
              case 0:
                // Connection
                json = jsonEncode(SpUtil.getObjList(
                    Keys.connections, (map) => Connection.fromJson(map)));
                fileName = 'connections.json';
                break;
              case 1:
                // Snippet
                // Connection
                json = jsonEncode(SpUtil.getObjList(
                    Keys.snippets, (map) => Snippet.fromJson(map)));
                fileName = 'snippets.json';
                break;
            }
            var f = File('${docDir.path}/$fileName');
            if (!await f.exists()) {
              await f.create();
            }
            await f.writeAsString(json);
            await Share.shareFiles(
              [f.path],
            );
          },
        ),
      ),
      child: SafeArea(
          child: ListView(
        children: [
          CupertinoFormSection(
              header: Text('EXPORT TYPE'),
              children:
                  _dataTypes.map((s) => buildChoiceItem(s, ++_i)).toList()),
        ],
      )),
    );
  }

  Widget buildChoiceItem(String text, int index) {
    return CupertinoFormRow(
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
}
