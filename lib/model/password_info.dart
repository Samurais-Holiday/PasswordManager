/// パスワード情報のデータクラス
class PasswordInfo {
  String title;
  String id;
  String password;
  String description;

  /// コンストラクタ
  PasswordInfo({required this.title, required this.id, required this.password, required this.description});

  /// 文字列検索
  bool contains(final String searchWord) => title.contains(searchWord) || description.contains(searchWord);
}