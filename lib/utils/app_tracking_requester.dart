import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AppTrackingRequester {
  static final AppTrackingRequester instance = AppTrackingRequester();

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      // ユーザーが回答済か否か（つまり初回起動か否か）の状態を取得
      TrackingStatus trackingStatusO = await AppTrackingTransparency.trackingAuthorizationStatus;
      debugPrint("trackingStatusO:$trackingStatusO");

      try {
        if (trackingStatusO == TrackingStatus.notDetermined) {
          // ATTダイアログ表示前に自作ダイアログを表示させた方が良い場合がある
          // https://halzoblog.com/error-bug-diary/20220530-2/
          // 現状は出さない

          // ATTダイアログ表示
          final status = await AppTrackingTransparency.requestTrackingAuthorization();
          debugPrint("trackingStatus1:$status");
        }
      } on PlatformException {
        debugPrint('PlatformException was thrown');
      }
    }
  }
}
