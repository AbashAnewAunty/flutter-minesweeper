# minesweeper

minesweeper application

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to test

テストコードを書いたら次のコマンドを実行

```bash
flutter pub run build_runner build

```

次のコマンドを実行してテスト（ファイル名は都度変更）

```bash
flutter test test/view_model/game_page_view_model.dart

```

app icon is from
https://www.flaticon.com/free-icon/bomb-detonation_7622036?term=bomb&page=2&position=1&origin=search&related_id=7622036

## 備忘録

### iOS最新バージョン更新方法

ref: <https://docs.flutter.dev/deployment/ios#review-xcode-project-settings>

1. XCode > Targets > Runnber > Generalタブ > Minimum Deployments の値更新
2. ios/Flutter/AppframeworkInfo.plist > MinimumOSVersion の値を1.と同じ値に更新
