import 'dart:async';

import 'package:pchat/constants/stream_subscreption_key.dart';

class StreamLisinerHelper {
  // final _initialMap = {
  //   StreamSubscreptionKey.chatSubsriptionKey:[],
  //   StreamSubscreptionKey.groupSubsriptionKey:[],
  //   StreamSubscreptionKey.userSubsriptionKey:[],

  // };
  static final Map<String, List<StreamSubscription>> _subscription = {
    StreamSubscreptionKey.chatSubsriptionKey: [],
    StreamSubscreptionKey.groupSubsriptionKey: [],
    StreamSubscreptionKey.userSubsriptionKey: [],
  };

  static void addChatSubscription(StreamSubscription subscription) {
    _subscription[StreamSubscreptionKey.chatSubsriptionKey]!.add(subscription);
  }

  static void addGroupSubscription(StreamSubscription subscription) {
    _subscription[StreamSubscreptionKey.groupSubsriptionKey]!.add(subscription);
  }

  static void addUserSubscription(StreamSubscription subscription) {
    _subscription[StreamSubscreptionKey.userSubsriptionKey]!.add(subscription);
  }

// close individual subscreption
  static Future<void> closeChatSubscription() async {
    for (var sub in _subscription[StreamSubscreptionKey.chatSubsriptionKey]!) {
      await sub.cancel();
    }
    _subscription[StreamSubscreptionKey.chatSubsriptionKey] = [];
  }

  static Future<void> closeGroupSubscription() async {
    for (var sub in _subscription[StreamSubscreptionKey.groupSubsriptionKey]!) {
      await sub.cancel();
    }
    _subscription[StreamSubscreptionKey.groupSubsriptionKey] = [];
  }

  static Future<void> closeUserSubscription() async {
    for (var sub in _subscription[StreamSubscreptionKey.userSubsriptionKey]!) {
      await sub.cancel();
    }
    _subscription[StreamSubscreptionKey.userSubsriptionKey] = [];
  }

  static Future<void> closeAllSubscription() async {
    await closeChatSubscription();
    await closeGroupSubscription();
    await closeUserSubscription();
  }
}
