import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/resultset.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class ResultsExportPage extends StatefulWidget {
  final ResultSet resultSet;

  const ResultsExportPage(this.resultSet, {Key? key}) : super(key: key);

  @override
  _ResultsExportPageState createState() => _ResultsExportPageState();
}

class _ResultsExportPageState extends State<ResultsExportPage> {
  @override
  void initState() {
    super.initState();
  }

  List<String> _exportTypes = [
    'Excel(*.xlsx)',
    'CSV(*.csv)',
    'JSON(*.json)',
    'XML(*.xml)',
    'Insert-SQL(*.sql)',
    'Batch-Insert-SQL(*.sql)'
  ];
  int _i = -1;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    _i = -1;
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey[200],
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Export'),
          onPressed: startExport,
        ),
      ),
      child: SafeArea(
          child: CupertinoFormSection(
              header: Text('EXPORT AS'),
              children:
                  _exportTypes.map((s) => buildChoiceItem(s, ++_i)).toList())),
    );
  }

  Widget buildChoiceItem(String text, int index) {
    return CupertinoFormRow(
        padding: EdgeInsets.only(left: 20),
        child: Row(children: [
          Expanded(
            flex: 7,
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
                  _index = index;
                });
              },
            ),
          ),
          Expanded(
              child: _index == index
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

  void startExport() async {
    List<int>? bytes;
    String filename = '';
    switch (_index) {
      case 0:
        // Excel
        var excel = Excel.createExcel();
        var sheet = excel.sheets['Sheet1'];
        sheet!.appendRow(widget.resultSet.header);
        widget.resultSet.data.forEach((e) {
          sheet.appendRow(e);
        });
        bytes = excel.save();
        filename = 'export.xlsx';
        break;
      case 1:
        // CSV
        String str = '';
        str += widget.resultSet.header.join(',');
        str += '\n';
        widget.resultSet.data.forEach((e) {
          str += e.join(',') + '\n';
        });
        bytes = Utf8Encoder().convert(str);
        filename = 'export.csv';
        break;
      case 2:
        // JSON
        String str = '';
        for (var i = 0; i < widget.resultSet.data.length; i++) {
          if (str != '') {
            str += ',';
          }
          var items = <String>[];
          for (var j = 0; j < widget.resultSet.data[i].length; j++) {
            String name = widget.resultSet.header[j];
            String value = widget.resultSet.data[i][j];
            items.add('''"$name":"$value"''');
          }
          str += """{${items.join(',')}}""";
          str += "\n";
        }
        bytes = Utf8Encoder().convert('''[$str]''');
        filename = 'export.json';
        break;
      case 3:
        // XML
        String str = '';
        for (var i = 0; i < widget.resultSet.data.length; i++) {
          str += '<Item>\n';
          for (var j = 0; j < widget.resultSet.data[i].length; j++) {
            String name = widget.resultSet.header[j];
            String value = widget.resultSet.data[i][j];
            str += "<$name>$value</$name>";
          }
          str += '</Item>\n';
        }
        bytes = Utf8Encoder().convert('''<root>$str</root>''');
        filename = 'export.xml';
        break;
      case 4:
        // Insert SQL
        String str = '';
        var columnSql = 'insert into table (' +
            widget.resultSet.header.join(',') +
            ') values (';
        widget.resultSet.data.forEach((e) {
          str += columnSql + "'" + e.join("','") + "');\n";
        });
        bytes = Utf8Encoder().convert(str);
        filename = 'export.sql';
        break;
      case 5:
        // Batch Insert SQL
        String str = 'insert into table (' +
            widget.resultSet.header.join(',') +
            ') values ';
        int c = 0;
        String str2 = '';
        widget.resultSet.data.forEach((e) {
          if (str2 != '') {
            str2 += ',';
          }
          str2 += "('" + e.join("','") + "')\n";
        });
        str += str2 + ";";
        bytes = Utf8Encoder().convert(str);
        filename = 'export.sql';
        break;
    }
    if (bytes != null) {
      var docDir = await getApplicationDocumentsDirectory();
      var f = File("${docDir.path}/$filename")
        ..create(recursive: true)
        ..writeAsBytes(bytes);
      await Share.shareFiles([f.path]);
    }
  }
}
