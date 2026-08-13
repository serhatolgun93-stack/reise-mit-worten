import '../../core/ids/character_id.dart';
import '../../core/ids/journey_instance_id.dart';
import 'character_knowledge_fact.dart';

abstract interface class CharacterKnowledgeRepository {
  Future<bool> knows(
    JourneyInstanceId journeyInstanceId,
    CharacterId characterId,
    String factType,
  );

  Future<CharacterKnowledgeFact?> getFact(
    JourneyInstanceId journeyInstanceId,
    CharacterId characterId,
    String factType,
  );
}
