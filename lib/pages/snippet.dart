import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/model/snippet.dart';
import 'package:mysql_client_flutter/pages/snippet_add.dart';
import 'package:mysql_client_flutter/pages/snippet_info.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:mysql_client_flutter/util/provider.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';
import 'package:sp_util/sp_util.dart';

class SnippetPage extends StatefulWidget {
  const SnippetPage({Key? key}) : super(key: key);
  @override
  _SnippetPageState createState() => _SnippetPageState();
}

class _SnippetPageState extends State<SnippetPage> {
  List<Snippet> _snippets = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1), () async => refreshSnippets());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('Snippet'),
            trailing: GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () async => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return SnippetAddPage();
              })).then((a) async {
                await refreshSnippets();
              }),
            )),
        child: SafeArea(
            child: ListView(children: [
          CupertinoFormSection(
              header: Text('SNIPPETS'),
              children: _snippets.isEmpty
                  ? [buildCupertinoFormNoDataRow('No snippet found')]
                  : _snippets.map((t) {
                      return CupertinoFormRow(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(children: [
                            Expanded(
                              flex: 10,
                              child: CupertinoButton(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.zero,
                                child: Text(
                                  t.alias,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () => {},
                              ),
                            ),
                            Expanded(
                                child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return SnippetInfoPage(t);
                                }));
                              },
                              child: Icon(
                                Icons.info_outline,
                              ),
                            )),
                            Expanded(
                                child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return SnippetAddPage(
                                    snippet: t,
                                    edit: true,
                                  );
                                })).then((value) => refreshSnippets());
                              },
                              child: Icon(Icons.edit),
                            )),
                            Expanded(
                                child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return SnippetAddPage(
                                      snippet: Snippet(t.alias + '_copy',
                                          t.remark + '_copy', t.body));
                                })).then((value) => refreshSnippets());
                              },
                              child: Icon(Icons.copy),
                            )),
                            Expanded(
                                child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                _snippets.remove(t);
                                SpUtil.putObjectList(Keys.snippets, _snippets);
                                refreshSnippets();
                              },
                              child: Icon(
                                CupertinoIcons.delete,
                                color: Colors.red,
                              ),
                            )),
                            Expanded(
                                child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Text(''),
                            )),
                          ]));
                    }).toList())
        ])));
  }

  Future<void> refreshSnippets() async {
    var snippets = await loadSnippets();
    _snippets.clear();
    setState(() {
      _snippets.addAll(snippets);
    });
  }
}
