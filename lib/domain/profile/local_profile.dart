import '../../core/ids/local_profile_id.dart';
final class LocalProfile { final LocalProfileId id; final DateTime createdAt; final String uiLocale; final String? displayName; const LocalProfile({required this.id,required this.createdAt,required this.uiLocale,this.displayName}); }
