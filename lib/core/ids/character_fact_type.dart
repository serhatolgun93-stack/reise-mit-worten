final class CharacterFactType {
  final String value;
  const CharacterFactType(this.value);

  @override
  bool operator ==(Object other) =>
      other is CharacterFactType && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
