import 'clock.dart';

final class SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now().toUtc();
}
