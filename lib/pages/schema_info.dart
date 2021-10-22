import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/schema.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';

class SchemaInfoPage extends StatefulWidget {
  final Schema schema;
  SchemaInfoPage(this.schema);
  @override
  _SchemaInfoPageState createState() => _SchemaInfoPageState();
}

class _SchemaInfoPageState extends State<SchemaInfoPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.grey[200],
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            widget.schema.name,
            style: TextStyle(color: Colors.black),
          ),
        ),
        child: SafeArea(
            child: ListView(children: [
          CupertinoFormSection(header: Text('SCHEMA Info.'), children: [
            buildCupertinoFormInfoRow('Name:', widget.schema.name),
            buildCupertinoFormInfoRow('Charset Name:', widget.schema.charset),
            buildCupertinoFormInfoRow('Collate Name:', widget.schema.collate),
          ])
        ])));
  }
}
