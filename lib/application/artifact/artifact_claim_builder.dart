import 'dart:convert';
import '../../domain/evidence/evidence_event.dart';

enum ArtifactClaimType { used, spoken, independentlyUsed, independentlySpoken }

final class ArtifactClaimBuilder {
  const ArtifactClaimBuilder();
  Set<ArtifactClaimType> build(Iterable<EvidenceEvent> evidence) {
    final successful=evidence.where((e)=>e.evidenceType==EvidenceType.application && e.semanticResult==EvidenceSemanticResult.success).toList();
    final claims=<ArtifactClaimType>{};
    if(successful.isNotEmpty)claims.add(ArtifactClaimType.used);
    if(successful.any((e)=>e.modality==EvidenceModality.speech))claims.add(ArtifactClaimType.spoken);
    bool independent(EvidenceEvent e){
      try { final m=jsonDecode(e.helpPayload) as Map<String,dynamic>; return (m['language_help_step'] as num? ?? 0).toInt()==0; } catch(_){ return false; }
    }
    if(successful.any(independent))claims.add(ArtifactClaimType.independentlyUsed);
    if(successful.any((e)=>e.modality==EvidenceModality.speech && independent(e)))claims.add(ArtifactClaimType.independentlySpoken);
    return claims;
  }
}
