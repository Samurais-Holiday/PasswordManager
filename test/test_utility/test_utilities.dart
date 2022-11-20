import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/model/password_info.dart';

class TestUtilities {
  /// パスワード情報の比較
  static void comparePasswords(List<PasswordInfo> actual, List<PasswordInfo> expected) {
    expect(actual.length, expected.length);
    for (int i = 0; i < actual.length; i++) {
      TestUtilities.comparePassword(actual[i], expected[i]);
    }
  }

  /// パスワード情報の比較
  static void comparePassword(PasswordInfo? actual, PasswordInfo? expected) {
    if (expected == null) {
      expect(actual, isNull);
      return;
    }
    expect(actual, isNotNull);
    expect(actual!.title, expected.title);
    expect(actual.id, expected.id);
    expect(actual.password, expected.password);
    expect(actual.memo, expected.memo);
  }
}