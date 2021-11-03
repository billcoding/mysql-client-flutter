import 'package:mysql_client_flutter/model/snippet.dart';
import 'package:mysql_client_flutter/strings/keys.dart';
import 'package:sp_util/sp_util.dart';

Future<List<Snippet>> loadSnippets() async {
  return SpUtil.getObjList(Keys.snippets, (map) => Snippet.fromJson(map)) ?? [];
}
