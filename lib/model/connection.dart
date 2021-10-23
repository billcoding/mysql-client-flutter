import 'package:dart_mysql/dart_mysql.dart';

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

  Future<MySqlConnection> connect() async {
    return await MySqlConnection.connect(ConnectionSettings(
      host: host,
      port: int.parse(port),
      user: user,
      db: database,
      password: password,
    ));
  }

  Connection.fromJson(Map<dynamic, dynamic> map)
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
