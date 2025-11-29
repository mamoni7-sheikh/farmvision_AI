// lib/services/network.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final Connectivity _connectivity = Connectivity();

  // --------------------------------------------------------
  // STREAM → emits TRUE (online) or FALSE (offline)
  // --------------------------------------------------------
  static Stream<bool> networkStatusStream() async* {
    // Initial check
    final initial = await _connectivity.checkConnectivity();
    yield _isOnline(initial);

    // Real-time updates supporting both:
    //  - ConnectivityResult (old)
    //  - List<ConnectivityResult> (new)
    yield* _connectivity.onConnectivityChanged.map((event) {
      return _isOnline(event);
    });
  }

  // --------------------------------------------------------
  // Check online status for both old + new API styles
  // --------------------------------------------------------
  static bool _isOnline(dynamic result) {
    // NEW API → List<ConnectivityResult>
    if (result is List<ConnectivityResult>) {
      return result.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet);
    }

    // OLD API → single value
    if (result is ConnectivityResult) {
      return result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
    }

    return false;
  }
}
