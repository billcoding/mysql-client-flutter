import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/snippet.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';

class SnippetInfoPage extends StatefulWidget {
  final Snippet snippet;
  SnippetInfoPage(this.snippet);
  @override
  _SnippetInfoPageState createState() => _SnippetInfoPageState();
}

class _SnippetInfoPageState extends State<SnippetInfoPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            widget.snippet.alias,
            style: TextStyle(color: Colors.black),
          ),
        ),
        child: SafeArea(
            child: ListView(children: [
          CupertinoFormSection(header: Text('SNIPPET Info.'), children: [
            buildCupertinoFormInfoRow('Alias', widget.snippet.alias),
            buildCupertinoFormInfoRow('Remark', widget.snippet.remark),
            buildCupertinoFormInfoRow('Body', widget.snippet.body),
          ])
        ])));
  }
}
