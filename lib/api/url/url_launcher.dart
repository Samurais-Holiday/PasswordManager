import 'package:url_launcher/url_launcher.dart';

/// URLを管理するクラス
class UrlLauncher {
  /// プライバシーポリシーURL
  static final Uri _privacyPolicy = Uri.parse('https://samurais-holiday.com/%e8%87%aa%e5%b7%b1%e7%b4%b9%e4%bb%8b/%e3%80%90simple%e3%80%91password-manager-android/%e3%80%90simple%e3%80%91password-manager-privacy-policy/');

  /// プライバシーポリシーのURLへ移動する
  static Future launchPrivacyPolicy() => launchUrl(_privacyPolicy);
}