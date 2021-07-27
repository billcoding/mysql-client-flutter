import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql_client_flutter/pages/connections/add.dart';
import 'package:sp_util/sp_util.dart';
import 'pages/home.dart';

void main() {
  runApp(App());
  SpUtil.getInstance();
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/connections/add': (BuildContext context) => AddPage(),
      },
    );
  }
}
