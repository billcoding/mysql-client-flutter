import 'package:mysql_client_flutter/model/connection.dart';
import 'package:mysql_client_flutter/model/snippet.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:sp_util/sp_util.dart';

Future<List<Snippet>> loadSnippets() async {
  return SpUtil.getObjList(Keys.snippets, (map) => Snippet.fromJson(map)) ?? [];
}

Future<List<Connection>> loadConnections() async {
  return SpUtil.getObjList(
          Keys.connections, (map) => Connection.fromJson(map)) ??
      [];
}

Future saveConnections(List<Connection> connections) async {
  await SpUtil.putObjectList(Keys.connections, connections);
}

Future saveSnippets(List<Snippet> snippets) async {
  await SpUtil.putObjectList(Keys.snippets, snippets);
}
