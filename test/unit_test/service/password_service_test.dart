import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/service/password_service.dart';

import '../../stub/repository/stub_password_repository.dart';

/// PasswordServiceクラスの単体テスト
void main() {
  final passwords = <PasswordInfo>[
    PasswordInfo(title: 'bankA', id: '12345', password: 'password1', memo: 'memo1'),
    PasswordInfo(title: 'bankB', id: '56789', password: 'password2', memo: 'memo2'),
    PasswordInfo(title: 'snsA', id: 'abcdef', password: 'password3', memo: 'memo3'),
  ];

  test('$PasswordService.search', () async {
    await _Utility.compareSizeOfSearchResult(passwords, {
          '' : 3,
          'bank' : 2,
          'A' : 2,
          '5' : 0,
          'password' : 0,
    });
  });
}

class _Utility {
  static Future compareSizeOfSearchResult(List<PasswordInfo> passwords, Map<String, int> expected) async {
    final service = PasswordService(StubPasswordRepository(passwords));
    expected.forEach((searchWord, expectedLength) async {
      final searchResults = await service.search(searchWord);
      expect(searchResults.length, expectedLength);
    });
  }
}