import 'package:uuid/uuid.dart';
import 'id_generator.dart';

final class UuidIdGenerator implements IdGenerator {
  final Uuid _uuid;
  UuidIdGenerator({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  @override
  String generate() => _uuid.v4();
}
