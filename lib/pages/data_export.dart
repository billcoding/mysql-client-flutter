import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  List<String> _dataTypes = [
    'Connections',
    'Snippets',
  ];

  List<String> _fileTypes = [
    'JSON(*.json)',
    'XML(*.xml)',
  ];
  int _i1 = -1;
  int _i2 = -1;
  int _index1 = 0;
  int _index2 = 0;

  @override
  Widget build(BuildContext context) {
    _i1 = -1;
    _i2 = -1;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Data Export'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Export'),
          onPressed: () async {},
        ),
      ),
      child: SafeArea(
          child: ListView(
        children: [
          CupertinoFormSection(
              header: Text('DATA TYPES'),
              children:
                  _dataTypes.map((s) => buildChoiceItem(s, ++_i1)).toList()),
          CupertinoFormSection(
              header: Text('FILE TYPES'),
              children: _fileTypes
                  .map((s) => buildChoiceItem(s, ++_i2, is2: true))
                  .toList()),
        ],
      )),
    );
  }

  Widget buildChoiceItem(String text, int index, {bool is2 = false}) {
    return CupertinoFormRow(
        padding: EdgeInsets.only(left: 20),
        child: Row(children: [
          Expanded(
            flex: 9,
            child: CupertinoButton(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                setState(() {
                  if (is2) {
                    _index2 = index;
                  } else {
                    _index1 = index;
                  }
                });
              },
            ),
          ),
          Expanded(
              child: (is2 ? _index2 : _index1) == index
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Icon(
                        Icons.check_outlined,
                      ),
                    )
                  : Text('')),
        ]));
  }
}
