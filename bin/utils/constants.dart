import 'package:dotenv/dotenv.dart' show load, env;
import 'package:nyxx/nyxx.dart';

class Tokens {
  /// Tokens for various API's

  static String BOT_TOKEN = '';
  static String BOT_OWNER = '';

  static String WOLFRAM_ID = '';
  static String YT_KEY = '';

  static void loadEnv() {
    load();

    BOT_TOKEN = env['BOT_TOKEN'].toString();
    BOT_OWNER = env['BOT_OWNER'].toString();

    WOLFRAM_ID = env['WA_ID'].toString();
    YT_KEY = env['YT_KEY'].toString();
  }
}

class Colors {
  /// Custom colors for various embeds

  static final Map<String, DiscordColor> AUDIT_COLORS = {
    'mod': DiscordColor.fromRgb(224, 108, 117),
    'msg_delete': DiscordColor.fromRgb(198, 120, 221),
    'msg_edit': DiscordColor.fromRgb(97, 175, 239),
    'say_cmd': DiscordColor.fromRgb(26, 179, 246),
  };
}

class Emojis {
  /// Custom unicode and discord Emojis

  static const String TICK = '<:tick:822469654710190080>';
  static const String CANCEL = '<:redTick:596576672149667840>';
}

class Names {
  /// Titles for embeds

  static final List<String> SUCCESS_LIST =
      ['Success!', 'Yay!', 'Woot!'].map((e) => '${Emojis.TICK} $e').toList();
  static final List<String> ERROR_LIST = ['Hold on there!', 'Umm...', 'Error!']
      .map((e) => '${Emojis.CANCEL} $e')
      .toList();
  static final Map<String, String> AUDIT_EMBED_FOOTER = {
    'mod': 'Command invoked by',
    'msg_delete': 'Message deleted by',
    'msg_edit': 'Message edited by',
    'say_msg': 'Command invoked by',
  };
}
