/// パスワード情報のデータクラス
class PasswordInfo {
  String title;
  String id;
  String password;
  String memo;

  /// コンストラクタ
  PasswordInfo({required this.title, required this.id, required this.password, required this.memo});

  /// 文字列検索
  bool hits(final String searchWord) => title.contains(searchWord) || memo.contains(searchWord);
}