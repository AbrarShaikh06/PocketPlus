/// Abstraction for connectivity checks used by repositories.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
