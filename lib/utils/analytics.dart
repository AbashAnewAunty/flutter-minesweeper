import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// 画面繊維ログ
/// NOTE: FirebaseAnalyticsによる自動画面追跡を無効にしている場合、
/// [logEvent]から処理を自作する必要がある
///　https://firebase.google.com/docs/analytics/screenviews?hl=ja#dart
Future logScreenView({required String screenName}) async {
  if (kDebugMode) {
    return;
  }
  await FirebaseAnalytics.instance.logEvent(
    name: 'screen_view',
    parameters: {
      /// 上記参考サイトでは、パラメータ「firebase_screen」としているが
      /// 実行すると、予約語なので利用できないと言われる「DebugView」
      'screen_name': screenName,
    },
  );
}
