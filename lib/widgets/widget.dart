import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCupertinoFormInfoRow(String name, String text,
    {TextAlign textAlign = TextAlign.right}) {
  return CupertinoFormRow(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(children: [
        Expanded(
            flex: 2,
            child: Text(name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
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

Widget buildTextField(String text, TextEditingController? controller,
    {bool password = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLength = 50,
    int maxLines = 1,
    required String placeholder}) {
  return CupertinoTextFormFieldRow(
    prefix: Text(text),
    obscureText: password,
    keyboardType: keyboardType,
    textAlign: TextAlign.right,
    controller: controller,
    maxLength: maxLength,
    maxLines: maxLines,
    textCapitalization: TextCapitalization.sentences,
    placeholder: placeholder,
    validator: (String? value) {
      return value == null || value.isEmpty ? 'Please enter this field.' : null;
    },
  );
}
