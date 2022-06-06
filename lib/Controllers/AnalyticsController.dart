import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final analyticsProvider =
    StateProvider<AnalyticsController>((ref) => AnalyticsController());

class AnalyticsController {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
}
