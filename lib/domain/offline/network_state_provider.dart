import 'offline_models.dart';
abstract interface class NetworkStateProvider {
  Future<NetworkKind> current();
  Stream<NetworkKind> get changes;
}
