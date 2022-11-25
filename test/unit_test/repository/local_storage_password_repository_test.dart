import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/repository/local_storage_password_repository.dart';

import '../../stub/storage/stub_storage.dart';
import '../../test_utility/test_utilities.dart';


/// LocalStoragePasswordRepositoryクラスの単体テスト
void main() {
  final passwords = <PasswordInfo>[
    PasswordInfo(title: 'Title1', id: 'id1', password: 'password1', memo: 'memo1'),
    PasswordInfo(title: 'Title2', id: '', password: '', memo: ''),
    PasswordInfo(title: 'Title3', id: '&&//', password: '&/&/', memo: '%'),
    PasswordInfo(title: 'Title4', id: '%&', password: '//%%', memo: '/'),
  ];
  final storageValues = <String, String>{
    'Title1' : r'id1/password1/memo1',
    'Title2' : r'%/%/%',                // id, password, memoが空
    'Title3' : r'&&&&&/&//&&&/&&&//&%', // id='&&//', password='&/&/', memo='%'
    'Title4' : r'&%&&/&/&/&%&%/&/',     // id='%&'  , password='//%%', memo='/'
  };
  final invalidStorageValues = <String, String>{
    'Title1' : 'id/password',
    'Title2' : 'id/password/memo/trash'
  };

  test('$LocalStoragePasswordRepository.findAll', () async {
    final repository = LocalStoragePasswordRepository(StubStorage(storageValues));
    final readPasswords = await repository.findAll();
    TestUtilities.comparePasswords(readPasswords, passwords);
  });

  test('$LocalStoragePasswordRepository.findAll(異常系/split失敗)', () async {
    final repository = LocalStoragePasswordRepository(StubStorage(invalidStorageValues));
    final readPasswords = await repository.findAll();
    expect(readPasswords.length, 0);
  });

  test('$LocalStoragePasswordRepository.find(正常系/データあり)', () async {
    final repository = LocalStoragePasswordRepository(StubStorage(storageValues));
    final readPassword = await repository.find(title: passwords[2].title);
    TestUtilities.comparePassword(readPassword, passwords[2]);
  });

  test('$LocalStoragePasswordRepository.fine(正常系/データなし)', () async {
    final repository = LocalStoragePasswordRepository(StubStorage(storageValues));
    final readPassword = await repository.find(title: 'NotContainsTitle');
    expect(readPassword, isNull);
  });

  test('$LocalStoragePasswordRepository.find(異常系/split失敗)', () async {
    final repository = LocalStoragePasswordRepository(StubStorage(invalidStorageValues));
    for (var title in invalidStorageValues.keys) {
      final readPassword = await repository.find(title: title);
      expect(readPassword, isNull);
    }
  });

  test('$LocalStoragePasswordRepository.add', () async {
    final storage = StubStorage();
    final repository = LocalStoragePasswordRepository(storage);
    for (var password in passwords) {
      await repository.add(password);
    }
    expect(await storage.readAll(), storageValues);
  });

  test('$LocalStoragePasswordRepository.update(正常系/タイトル変更あり)', () async {
    final storage = StubStorage(storageValues);
    final repository = LocalStoragePasswordRepository(storage);
    final newPassword = PasswordInfo(title: 'newTitle', id: 'newID', password: 'newPassword', memo: '');
    await repository.update(oldTitle: passwords[0].title, newPassword: newPassword);
    expect(await storage.read(title: passwords[0].title), isNull);
    expect(await storage.read(title: newPassword.title), isNotNull);
  });

  test('$LocalStoragePasswordRepository.update(正常系/タイトル変更なし)', () async {
    final storage = StubStorage(storageValues);
    final repository = LocalStoragePasswordRepository(storage);
    final newPassword = PasswordInfo(title: passwords[0].title, id: 'newID', password: 'newPassword', memo: 'newMemo');
    await repository.update(oldTitle: passwords[0].title, newPassword: newPassword);
    expect(await storage.read(title: passwords[0].title), isNotNull);
  });

  test('$LocalStoragePasswordRepository.delete', () async {
    final storage = StubStorage(storageValues);
    final repository = LocalStoragePasswordRepository(storage);
    await repository.delete(title: passwords[0].title);
    expect(await storage.read(title: passwords[0].title), isNull);
  });
}
