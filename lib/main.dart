import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sp_util/sp_util.dart';
import 'pages/connections/home.dart';

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
      builder: () {
        var widget = EasyLoading.init();
        EasyLoading.instance
              ..displayDuration = const Duration(seconds: 2)
              ..indicatorType = EasyLoadingIndicatorType.ring
              ..loadingStyle = EasyLoadingStyle.light
            // ..indicatorSize = 45.0
            // ..radius = 10.0
            // ..progressColor = Colors.red
            // ..backgroundColor = Colors.white
            // ..indicatorColor = Colors.black
            // ..textColor = Colors.black
            // ..maskColor = Colors.blue
            // ..userInteractions = false
            // ..dismissOnTap = false;
            ;
        return widget;
      }(),
    );
  }
}
