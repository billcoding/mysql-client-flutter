import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'MySQL Client',
          style: TextStyle(color: Colors.black),
        ),
        trailing: GestureDetector(
          child: Icon(Icons.add),
          onTap: () => Navigator.pushNamed(context, '/connections/add'),
        ),
        backgroundColor: Colors.white,
      ),
      child: Center(
        child: Text('Connections'),
      ),
    );
  }
}
