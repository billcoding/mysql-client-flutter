import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';

String ping(String host) {
  var start = DateTime.now().millisecondsSinceEpoch;
  var end = 0;
  try {
    final ping = Ping(
      host,
      count: 1,
      timeout: 1,
      interval: 1,
      ipv6: false,
    );
    ping.stream.listen((event) {});
    ping.stop();
    end = DateTime.now().millisecondsSinceEpoch;
  } catch (e) {
    return 'fail';
  }
  print('start = $start');
  print('end = $end');
  return '${end - start}ms';
}
