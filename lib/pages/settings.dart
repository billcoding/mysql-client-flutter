import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client_flutter/pages/data_export.dart';
import 'package:mysql_client_flutter/pages/data_import.dart';
import 'package:mysql_client_flutter/pages/snippet.dart';
import 'package:mysql_client_flutter/strings/vendor.dart';
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
              buildCupertinoFormButtonRow('Snippets', () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SnippetPage();
                }));
              }),
            ]),
            CupertinoFormSection(header: Text('TRANSFER'), children: [
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
                buildCupertinoFormButtonRow(
                    'Visit Project', () async => await launch(repoURL)),
                buildCupertinoFormButtonRow(
                    'Request Issue', () async => await launch(issuesURL)),
                buildCupertinoFormButtonRow(
                    'Contact Us', () async => await launch(mailTo)),
              ],
            ),
            CupertinoFormSection(
              header: Text('COPYRIGHT'),
              children: [
                buildCupertinoFormInfoRow('Version', version),
                buildCupertinoFormInfoRow('Copyright', copyright),
              ],
            )
          ],
        )));
  }
}
