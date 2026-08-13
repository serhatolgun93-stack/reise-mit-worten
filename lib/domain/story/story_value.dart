final class StoryValue {
  final String key;
  final String type;
  final String payload;
  final String sourceEventId;
  final DateTime updatedAt;

  const StoryValue({
    required this.key,
    required this.type,
    required this.payload,
    required this.sourceEventId,
    required this.updatedAt,
  });
}
