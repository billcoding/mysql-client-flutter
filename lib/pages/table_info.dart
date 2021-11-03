import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/table.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';

class TableInfoPage extends StatefulWidget {
  final DBTable table;
  TableInfoPage(this.table);
  @override
  _TableInfoPageState createState() => _TableInfoPageState();
}

class _TableInfoPageState extends State<TableInfoPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            widget.table.tableName,
            style: TextStyle(color: Colors.black),
          ),
        ),
        child: SafeArea(
            child: ListView(children: [
          CupertinoFormSection(header: Text('TABLE Info.'), children: [
            buildCupertinoFormInfoRow(
                'Table Catalog', widget.table.tableCatalog),
            buildCupertinoFormInfoRow('Table Schema', widget.table.tableSchema),
            buildCupertinoFormInfoRow('Table Name', widget.table.tableName),
            buildCupertinoFormInfoRow('Table Type', widget.table.tableType),
            buildCupertinoFormInfoRow(
                'Table Collation', widget.table.tableCollation),
            buildCupertinoFormInfoRow(
                'Table Comment', widget.table.tableComment),
            buildCupertinoFormInfoRow('Table Rows', widget.table.tableRows),
            buildCupertinoFormInfoRow('Engine', widget.table.engine),
            buildCupertinoFormInfoRow('Version', widget.table.version),
            buildCupertinoFormInfoRow('Row Format', widget.table.rowFormat),
            buildCupertinoFormInfoRow(
                'Avg Row Length', widget.table.avgRowLength + ' Bytes'),
            buildCupertinoFormInfoRow(
                'Data Length', widget.table.dataLength + ' Bytes'),
            buildCupertinoFormInfoRow(
                'Max Data Length', widget.table.maxDataLength + ' Bytes'),
            buildCupertinoFormInfoRow(
                'Index Length', widget.table.indexLength + ' Bytes'),
            buildCupertinoFormInfoRow(
                'Data Free', widget.table.dataFree + ' Bytes'),
            buildCupertinoFormInfoRow(
                'Auto Increment', widget.table.autoIncrement),
            buildCupertinoFormInfoRow('Create Time', widget.table.createTime),
            buildCupertinoFormInfoRow('Update Time', widget.table.updateTime),
            buildCupertinoFormInfoRow('Check Time', widget.table.checkTime),
          ])
        ])));
  }
}
