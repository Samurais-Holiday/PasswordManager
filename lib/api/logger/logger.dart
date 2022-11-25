import 'package:logger/logger.dart' as logger_library;

/// ロガークラス
class Logger {
  static final logger_library.Logger _logger = logger_library.Logger(
    level: logger_library.Level.debug,
    printer: logger_library.SimplePrinter(
      printTime: false,
    )
  ); ///< https://pub.dev/packages/logger

  static void debug(final String message) => _logger.d(_createHeader() + message);
  static void info(final String message) => _logger.i(_createHeader() + message);
  static void warning(final String message) => _logger.w(_createHeader() + message);
  static void error(final String message) => _logger.e(_createHeader() + message);

  /// ヘッダー作成
  static String _createHeader() {

    return ''; // TODO: 必要に応じて作成する
  }
}