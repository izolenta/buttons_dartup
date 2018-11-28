import 'dart:async';

class SubscriberMixin {
  final List<StreamSubscription> subscriptions = [];

  void cancelSubscriptions() {
    subscriptions.forEach((_) => _.cancel());
  }
}