import 'dart:io';

Future<String> testPing(String host, int port) async {
  var start = DateTime.now().millisecondsSinceEpoch;
  var end = 0;
  await RawSocket.connect(host, port, timeout: Duration(seconds: 1))
      .then((socket) {
    socket.close();
    end = DateTime.now().millisecondsSinceEpoch;
    print('ping: $host,$port success');
  }).onError((error, stackTrace) {
    print('ping: $host,$port $error'); 
  });
  print('start = $start');
  print('end = $end');
  if (end == 0) {
    return 'fail';
  }
  return '${end - start}ms';
}
