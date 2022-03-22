import 'package:dotenv/dotenv.dart' show load, env;
import 'package:nyxx/nyxx.dart';

class Tokens {
  /// Tokens for various API's

  static String botToken = '';
  static String botOwner = '';
  static String botId = '';

  static late String supabaseUrl;
  static late String supabaseKey;

  static String wolframId = '';
  static String ytKey = '';
  static String movieApiKey = '';

  static void loadEnv() {
    load('.env');

    botToken = env['BOT_TOKEN'].toString();
    botOwner = env['BOT_OWNER'].toString();
    botId = env['BOT_ID'].toString();

    supabaseUrl = env['SUPABASE_URL'].toString();
    supabaseKey = env['SUPABASE_KEY'].toString();

    wolframId = env['WA_ID'].toString();
    ytKey = env['YT_KEY'].toString();
    movieApiKey = env['MOVIE_API_KEY'].toString();
  }
}

class Colors {
  /// Custom colors for various embeds

  static final Map<String, DiscordColor> auditColors = {
    'mod': DiscordColor.fromRgb(224, 108, 117),
    'msg_delete': DiscordColor.fromRgb(198, 120, 221),
    'msg_edit': DiscordColor.fromRgb(97, 175, 239),
    'say_cmd': DiscordColor.fromRgb(26, 179, 246),
    'member': DiscordColor.blurple
  };
}

class Emojis {
  /// Custom unicode and discord Emojis

  static const tick = '<a:tick:894228435025690624>';
  static const cancel = '<a:cancel:894228934026199050>';
  static const rip = '<:rip:894236412696748032>';
  static const vcMute = '<:vcmute:894228535122735124>';
  static const vcUnmute = '<:vcunmute:894228326510624789>';
  static const warning = '<:warning:894230113242193930>';
  static const question = '<:question:894232833005092894>';
  static const staff = '<:staff:894230173170434098>';
  static const mod = '<:modshield:894230053620178954>';
  static const music = '<:Spotify_Cursed:895153940461678632>';

  static const logo = """\n\n
░█████╗░██████╗░░██████╗██╗██████╗░██╗░█████╗░███╗░░██╗
██╔══██╗██╔══██╗██╔════╝██║██╔══██╗██║██╔══██╗████╗░██║
██║░░██║██████╦╝╚█████╗░██║██║░░██║██║███████║██╔██╗██║
██║░░██║██╔══██╗░╚═══██╗██║██║░░██║██║██╔══██║██║╚████║
╚█████╔╝██████╦╝██████╔╝██║██████╔╝██║██║░░██║██║░╚███║
░╚════╝░╚═════╝░╚═════╝░╚═╝╚═════╝░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝\n\n""";
}

class Names {
  /// Titles for embeds

  static final List<String> successList =
      ['Success!', 'Yay!', 'Woot!'].map((e) => '${Emojis.tick} $e').toList();
  static final List<String> errorList = ['Hold on there!', 'Umm...', 'Error!']
      .map((e) => '${Emojis.cancel} $e')
      .toList();
  static final Map<String, String> auditEmbedFooter = {
    'mod': 'Command invoked by',
    'msg_delete': 'Message deleted by',
    'msg_edit': 'Message edited by',
    'say_msg': 'Command invoked by',
    'member': 'Command invoked by'
  };
}
