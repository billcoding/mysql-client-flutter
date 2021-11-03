class Snippet {
  final String alias;
  final String remark;
  final String body;

  Snippet(
    this.alias,
    this.remark,
    this.body,
  );

  Snippet.fromJson(Map<dynamic, dynamic> map)
      : alias = map["alias"],
        remark = map["remark"],
        body = map["body"];

  Map<String, dynamic> toJson() {
    return {'alias': alias, 'remark': remark, 'body': body};
  }
}
