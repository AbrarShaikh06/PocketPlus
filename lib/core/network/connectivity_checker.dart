import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'network_info.dart';

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

/// Reactive online/offline status. Emits the current state immediately, then
/// updates on every connectivity change so the UI can recover automatically
/// once the device regains a network.
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  Stream<bool> statusStream() async* {
    final initial = await connectivity.checkConnectivity();
    yield !initial.contains(ConnectivityResult.none);
    yield* connectivity.onConnectivityChanged
        .map((results) => !results.contains(ConnectivityResult.none));
  }

  return statusStream();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return ConnectivityChecker(ref.watch(connectivityProvider));
});

class ConnectivityChecker implements NetworkInfo {
  ConnectivityChecker(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
