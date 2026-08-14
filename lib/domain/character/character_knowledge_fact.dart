import '../../core/ids/character_id.dart';
import '../../core/ids/journey_instance_id.dart';
final class CharacterKnowledgeFact { final JourneyInstanceId journeyInstanceId; final CharacterId characterId; final String factType; final String valueRef; final String learnedFromEventId; final DateTime learnedAt; const CharacterKnowledgeFact({required this.journeyInstanceId,required this.characterId,required this.factType,required this.valueRef,required this.learnedFromEventId,required this.learnedAt}); }
