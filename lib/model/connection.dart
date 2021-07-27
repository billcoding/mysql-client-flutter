class Connection {
  String host;
  String port;
  String user;
  String password;
  String database;
  String alias;
  Connection(
    this.host,
    this.port,
    this.user,
    this.password,
    this.database,
    this.alias,
  );

  Connection.fromJson(Map<String, dynamic> map)
      : host = map["host"],
        port = map["port"],
        user = map["user"],
        password = map["password"],
        database = map["database"],
        alias = map["alias"];

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'port': port,
      'user': user,
      'password': password,
      'database': database,
      'alias': alias,
    };
  }
}
