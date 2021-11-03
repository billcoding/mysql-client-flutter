import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:mysql_client_flutter/pages/data_export.dart';
import 'package:mysql_client_flutter/pages/data_import.dart';
import 'package:mysql_client_flutter/pages/snippet.dart';
import 'package:mysql_client_flutter/strings/owner.dart';
import 'package:mysql_client_flutter/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Setting'),
        ),
        child: SafeArea(
            child: ListView(
          children: [
            CupertinoFormSection(header: Text('GENERAL'), children: [
              buildCupertinoFormButtonRow('Theme', () {}),
              buildCupertinoFormButtonRow('Font', () {}),
              buildCupertinoFormButtonRow('Snippets', () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SnippetPage();
                }));
              }),
            ]),
            CupertinoFormSection(header: Text('DATA TRANSFER'), children: [
              buildCupertinoFormButtonRow('Import', () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return DataImportPage();
                }));
              }),
              buildCupertinoFormButtonRow('Export', () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return DataExportPage();
                }));
              }),
            ]),
            CupertinoFormSection(
              header: Text('ABOUT'),
              children: [
                buildCupertinoFormButtonRow('Contact us', () async {
                  final mailtoLink = Mailto(to: [email], subject: emailSubject);
                  await launch('$mailtoLink');
                }),
                buildCupertinoFormButtonRow('Visit project', () async {
                  await launch(repoURL);
                }),
                buildCupertinoFormButtonRow('Request issue', () async {
                  await launch(issuesURL);
                }),
              ],
              footer: Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Copyright @2021',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )));
  }
}
