class ResultSet {
  final bool query;
  final int affectedRows;
  final List<List<String>> data;
  ResultSet(this.query, this.affectedRows, this.data);
}
