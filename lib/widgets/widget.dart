import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCupertinoFormInfoRow(String name, String text,
    {TextAlign textAlign = TextAlign.right}) {
  return CupertinoFormRow(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(children: [
        Expanded(flex: 2, child: Text(name, style: TextStyle(fontSize: 16))),
        Expanded(
            flex: 3,
            child: Text(text,
                style: TextStyle(fontSize: 14), textAlign: textAlign)),
      ]));
}

Widget buildCupertinoFormNoDataRow(String text) {
  return CupertinoFormRow(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(children: [
        Expanded(
            child: Text(
          text,
          style: TextStyle(fontSize: 18),
        )),
      ]));
}

Widget buildCupertinoFormButtonRow(String text, Function() onPressed) {
  return CupertinoFormRow(
      padding: EdgeInsets.only(left: 20),
      child: Row(children: [
        Expanded(
          flex: 7,
          child: CupertinoButton(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black),
            ),
            onPressed: onPressed,
          ),
        ),
      ]));
}
