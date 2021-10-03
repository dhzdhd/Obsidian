import 'package:dotenv/dotenv.dart' show load, env;
import 'package:nyxx/nyxx.dart';

class Tokens {
  /// Tokens for various API's

  static String BOT_TOKEN = '';
  static String BOT_OWNER = '';

  static late String POSTGRE_PASSWORD;
  static late String POSTGRE_DSN;
  static String POSTGRE_HOST = 'db.ojifljiksrbwrtcaaurw.supabase.co';
  static String POSTGRE_USER = 'postgres';
  static int POSTGRE_PORT = 6543;
  static String POSTGRE_DATABASE = 'postgres';

  static late String SUPABASE_URL;
  static late String SUPABASE_KEY;

  static String WOLFRAM_ID = '';
  static String YT_KEY = '';

  static void loadEnv() {
    // Switch between dev and stable .env's
    load('.env');

    BOT_TOKEN = env['BOT_TOKEN'].toString();
    BOT_OWNER = env['BOT_OWNER'].toString();

    POSTGRE_PASSWORD = env['POSTGRE_PASSWORD'].toString();
    POSTGRE_DSN = env['POSTGRE_DSN'].toString();

    SUPABASE_URL = env['SUPABASE_URL'].toString();
    SUPABASE_KEY = env['SUPABASE_KEY'].toString();

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
  static const RIP = '<:RIP:772044046390394880>';
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
