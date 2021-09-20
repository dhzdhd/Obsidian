import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'interactions/fun/basic.dart';
import 'interactions/fun/wolfram.dart';
import 'interactions/fun/youtube.dart';
import 'interactions/mod/essential.dart';
import 'interactions/mod/mute.dart';
import 'interactions/mod/warn_ban.dart';
import 'interactions/utils/bookmark.dart';
import 'interactions/utils/common.dart';
import 'package:logging/logging.dart' show Logger, Level;
import 'interactions/utils/eval.dart';
import 'interactions/utils/math.dart';
import 'interactions/utils/poll.dart';
import 'utils/constants.dart' show Tokens;
import 'utils/database.dart' show Database;
import 'utils/roles.dart';

late Nyxx bot;
late Interactions botInteractions;

void main() async {
  Tokens.loadEnv();
  Database();

  // Logger.root.level = Level.FINE;

  bot = Nyxx(Tokens.BOT_TOKEN, GatewayIntents.all,
      options: ClientOptions(
        initialPresence: PresenceBuilder.of(
          status: UserStatus.online,
          activity: ActivityBuilder('VALORANT', ActivityType.streaming,
              url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
        ),
      ));

  botInteractions = Interactions(bot);

  // TODO: tictactoe,

  // Fun interactions
  FunBasicInteractions();
  FunWolframInteractions();
  FunYoutubeInteractions();

  // Mod interactions
  ModEssentialInteractions();
  // ModMuteInteractions();
  // ModWarnBanInteractions();

  // Utils interactions
  // UtilsCommonInteractions();
  UtilsBookmarkInteractions();
  // UtilsPollInteractions();
  UtilsEvalInteractions();
  UtilsMathInteractions();
  UtilsRolesInteractions();

  botInteractions.syncOnReady();

  bot.onReady.listen((ReadyEvent e) async {
    print('Ready!');
  });

  bot.onDisconnect.listen((DisconnectEvent event) async {
    await Database.connection.close();
  });
}
