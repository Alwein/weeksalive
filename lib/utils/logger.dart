import 'package:logger/logger.dart';

final AppLogger log = AppLogger();

class AppLogger extends Logger {
  AppLogger()
      : super(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 100,
            printEmojis: false,
          ),
        );
  final List<String> _logs = [];

  String get logs => _logs.join("\n");

  @override
  void log(Level level, dynamic message, {Object? error, StackTrace? stackTrace, DateTime? time}) {
    if (_logs.length > 100) {
      _logs.removeAt(0);
    }
    _logs.add(message.toString());
    super.log(level, message, error: error, stackTrace: stackTrace, time: time);
  }
}
