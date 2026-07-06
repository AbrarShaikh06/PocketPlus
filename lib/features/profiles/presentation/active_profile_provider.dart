import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveProfileNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void switchProfile(String profileId) {
    state = profileId;
  }
}

final activeProfileProvider =
    NotifierProvider<ActiveProfileNotifier, String?>(ActiveProfileNotifier.new);
