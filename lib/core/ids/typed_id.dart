abstract class TypedId {
  final String value;
  const TypedId.validated(this.value);

  static String validate(String value, String typeName) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('$typeName must not be empty');
    }
    return normalized;
  }

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType && other is TypedId && value == other.value;

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => value;
}
