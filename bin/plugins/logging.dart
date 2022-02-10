import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:nyxx/src/nyxx.dart';
import 'package:nyxx/src/plugin/plugin.dart';

import '../utils/constants.dart';

class CustomLogging extends BasePlugin {
  static late final File logFile;

  static Future<void> initLogFile() async {
    logFile = await File.fromUri(
      Uri(path: 'logs/bot.log'),
    ).create(recursive: true);
  }

  @override
  FutureOr<void> onRegister(INyxx nyxx, Logger logger) {
    Logger.root.onRecord.listen((LogRecord rec) {
      final message =
          "[${rec.time}] [${rec.level.name}] [${rec.loggerName}] ${rec.message}";
      print(message);

      logFile.writeAsStringSync('$message\n', mode: FileMode.append);
    });
  }

  @override
  FutureOr<void> onBotStart(INyxx nyxx, Logger logger) async {
    logFile.writeAsStringSync(Emojis.logo);
    logFile.writeAsStringSync("\n\n\n${'*' * 50}\n\n\n", mode: FileMode.append);

    print(Emojis.logo);
  }
}
