import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future showToast(BuildContext context, String text, {int seconds = 3}) async {
  var t = FToast();
  t.init(context);
  t.showToast(child: Text(text), toastDuration: Duration(seconds: seconds));
}
