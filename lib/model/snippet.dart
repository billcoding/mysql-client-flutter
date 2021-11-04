class Snippet {
  final String alias;
  final String remark;
  final String body;

  Snippet(
    this.alias,
    this.remark,
    this.body,
  );

  factory Snippet.fromJson(dynamic json) {
    return Snippet(json["alias"] as String, json["remark"] as String,
        json["body"] as String);
  }

  Map<String, dynamic> toJson() {
    return {'alias': alias, 'remark': remark, 'body': body};
  }
}
