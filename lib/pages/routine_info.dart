import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/routine.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';

class RoutineInfoPage extends StatefulWidget {
  final Routine routine;
  RoutineInfoPage(this.routine);
  @override
  _RoutineInfoPageState createState() => _RoutineInfoPageState();
}

class _RoutineInfoPageState extends State<RoutineInfoPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            widget.routine.name,
            style: TextStyle(color: Colors.black),
          ),
        ),
        child: SafeArea(
            child: ListView(children: [
          CupertinoFormSection(header: Text('Routine Info.'), children: [
            buildCupertinoFormInfoRow(
                'Routine Catalog', widget.routine.catalog),
            buildCupertinoFormInfoRow('Routine Schema', widget.routine.schema),
            buildCupertinoFormInfoRow('Routine Name', widget.routine.name),
            buildCupertinoFormInfoRow(
                'Routine Security Type', widget.routine.securityType),
            buildCupertinoFormInfoRow(
                'Routine Collation', widget.routine.collation),
            buildCupertinoFormInfoRow('Charset Name', widget.routine.charset),
            buildCupertinoFormInfoRow('SQL Mode', widget.routine.sqlMode),
            buildCupertinoFormInfoRow(
                'Routine Parameter', widget.routine.parameters),
            buildCupertinoFormInfoRow('Create Time', widget.routine.createTime),
            buildCupertinoFormInfoRow(
                'Routine definition', widget.routine.definition,
                textAlign: TextAlign.left),
          ])
        ])));
  }
}
