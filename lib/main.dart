import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sp_util/sp_util.dart';
import 'pages/connection.dart';

void main() {
  runApp(App());
  SpUtil.getInstance();
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: ConnectionPage(),
      builder: () {
        var widget = EasyLoading.init();
        EasyLoading.instance
          ..userInteractions = false
          ..displayDuration = const Duration(seconds: 2)
          ..indicatorType = EasyLoadingIndicatorType.ring
          ..loadingStyle = EasyLoadingStyle.light;
        return widget;
      }(),
    );
  }
}
