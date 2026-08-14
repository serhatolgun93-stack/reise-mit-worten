enum StoryValueType { text, entity, boolean, number }
enum StoryValueSensitivity { standard, personal }
final class StoryValueDefinition { final String key; final StoryValueType type; final StoryValueSensitivity sensitivity; const StoryValueDefinition(this.key,this.type,this.sensitivity); }
abstract final class StoryValueRegistry { static const userName=StoryValueDefinition('STORY.USER.NAME',StoryValueType.text,StoryValueSensitivity.personal); static const orderedItem=StoryValueDefinition('STORY.ORDERED_ITEM',StoryValueType.entity,StoryValueSensitivity.standard); static StoryValueDefinition? byKey(String key)=>switch(key){'STORY.USER.NAME'=>userName,'STORY.ORDERED_ITEM'=>orderedItem,_=>null}; }
