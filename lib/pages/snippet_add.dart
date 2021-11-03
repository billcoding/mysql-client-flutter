import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/snippet.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:mysql_client_flutter/util/toast.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';
import 'package:sp_util/sp_util.dart';

class SnippetAddPage extends StatefulWidget {
  final Snippet? snippet;
  final int index;
  final bool edit;
  SnippetAddPage({Key? key, this.snippet, this.index = 0, this.edit = false})
      : super(key: key);
  @override
  _SnippetAddPageState createState() => _SnippetAddPageState();
}

class _SnippetAddPageState extends State<SnippetAddPage> {
  late TextEditingController _aliasController;
  late TextEditingController _remarkController;
  late TextEditingController _bodyController;
  bool _saveEnabled = true;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    var snippet = widget.snippet;
    _aliasController = TextEditingController(text: snippet?.alias);
    _remarkController = TextEditingController(text: snippet?.remark);
    _bodyController = TextEditingController(text: snippet?.body);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text(
              widget.edit
                  ? 'edit: ${widget.snippet!.alias}'
                  : 'add' +
                      (widget.snippet != null
                          ? (': copy from ' + widget.snippet!.alias)
                          : ''),
              style: TextStyle(color: Colors.black),
            ),
            trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text('Save'),
                onPressed: () {
                  if (_saveEnabled) {
                    save(context);
                  }
                })),
        child: SafeArea(
            child: ListView(children: [
          Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: [
                buildCupertinoFormSection('SNIPPET', [
                  buildTextField('Alias', _aliasController,
                      placeholder: "holdon", maxLength: 10),
                  buildTextField('Remark', _remarkController,
                      placeholder: "snippet for holdon", maxLength: 20),
                  buildTextField('Body', _bodyController,
                      placeholder: "SELECT 'holdon';"),
                ]),
              ]))
        ])));
  }

  CupertinoFormSection buildCupertinoFormSection(
      String headerText, List<Widget> children) {
    return CupertinoFormSection(
      header: Text(headerText),
      children: children,
    );
  }

  Future<void> save(BuildContext context) async {
    _saveEnabled = false;
    var validated = _formKey.currentState?.validate();
    if (validated == false) {
      _saveEnabled = true;
      return;
    }
    var snippet = createSnippet();
    if (SpUtil.containsKey(Keys.snippets) ?? false) {
      var snippets =
          SpUtil.getObjList(Keys.snippets, (map) => Snippet.fromJson(map)) ??
              [];
      if (widget.edit) {
        // edit
        snippets[widget.index] = snippet;
      } else {
        snippets.add(snippet);
      }
      SpUtil.putObjectList(Keys.snippets, snippets);
    } else {
      SpUtil.putObjectList(Keys.snippets, [snippet]);
    }
    showToast(context, 'Save success');
    _saveEnabled = true;
    Navigator.pop(context);
  }

  Snippet createSnippet() {
    String alias = _aliasController.text;
    String remark = _remarkController.text;
    String body = _bodyController.text;
    return Snippet(alias, remark, body);
  }
}
