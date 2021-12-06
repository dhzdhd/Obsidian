import 'package:dotenv/dotenv.dart' show load, env;
import 'package:nyxx/nyxx.dart';

class Tokens {
  /// Tokens for various API's

  static String BOT_TOKEN = '';
  static String BOT_OWNER = '';
  static String BOT_ID = '';

  static late String SUPABASE_URL;
  static late String SUPABASE_KEY;

  static String WOLFRAM_ID = '';
  static String YT_KEY = '';
  static String MOVIE_API_KEY = '';

  static void loadEnv() {
    load('.env');

    BOT_TOKEN = env['BOT_TOKEN'].toString();
    BOT_OWNER = env['BOT_OWNER'].toString();
    BOT_ID = env['BOT_ID'].toString();

    SUPABASE_URL = env['SUPABASE_URL'].toString();
    SUPABASE_KEY = env['SUPABASE_KEY'].toString();

    WOLFRAM_ID = env['WA_ID'].toString();
    YT_KEY = env['YT_KEY'].toString();
    MOVIE_API_KEY = env['MOVIE_API_KEY'].toString();
  }
}

class Colors {
  /// Custom colors for various embeds

  static final Map<String, DiscordColor> AUDIT_COLORS = {
    'mod': DiscordColor.fromRgb(224, 108, 117),
    'msg_delete': DiscordColor.fromRgb(198, 120, 221),
    'msg_edit': DiscordColor.fromRgb(97, 175, 239),
    'say_cmd': DiscordColor.fromRgb(26, 179, 246),
    'member': DiscordColor.blurple
  };
}

class Emojis {
  /// Custom unicode and discord Emojis

  static const String TICK = '<a:tick:894228435025690624>';
  static const String CANCEL = '<a:cancel:894228934026199050>';
  static const String RIP = '<:rip:894236412696748032>';
  static const String VC_MUTE = '<:vcmute:894228535122735124>';
  static const String VC_UNMUTE = '<:vcunmute:894228326510624789>';
  static const String WARNING = '<:warning:894230113242193930>';
  static const String QUESTION = '<:question:894232833005092894>';
  static const String STAFF = '<:staff:894230173170434098>';
  static const String MOD = '<:modshield:894230053620178954>';
  static const String MUSIC = '<:Spotify_Cursed:895153940461678632>';
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
    'member': 'Command invoked by'
  };
}
