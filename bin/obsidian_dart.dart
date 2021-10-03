import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'interactions/fun/basic.dart';
import 'interactions/fun/wolfram.dart';
import 'interactions/fun/youtube.dart';
import 'interactions/mod/essential.dart';
import 'interactions/mod/mute.dart';
import 'interactions/mod/vc.dart';
import 'interactions/mod/warn_ban.dart';
import 'interactions/utils/bookmark.dart';
import 'interactions/utils/common.dart';
import 'interactions/utils/db_utils.dart';
import 'interactions/utils/eval.dart';
import 'interactions/utils/math.dart';
import 'interactions/utils/poll.dart';
import 'utils/constants.dart' show Tokens;
import 'utils/database.dart' show initDatabase;
import 'interactions/utils/roles.dart';

late Nyxx bot;
late Interactions botInteractions;

void main() async {
  Tokens.loadEnv();
  initDatabase();

  bot = Nyxx(Tokens.BOT_TOKEN, GatewayIntents.all,
      options: ClientOptions(
        initialPresence: PresenceBuilder.of(
          status: UserStatus.online,
          activity: ActivityBuilder("your DM's 👀", ActivityType.listening,
              url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
        ),
      ));

  botInteractions = Interactions(bot);

  // Fun interactions
  FunBasicInteractions();
  FunWolframInteractions();
  FunYoutubeInteractions();

  // Mod interactions
  ModEssentialInteractions();
  // ModMuteInteractions();
  ModWarnBanInteractions();
  ModVcInteractions();

  // Utils interactions
  UtilsCommonInteractions();
  UtilsBookmarkInteractions();
  // UtilsPollInteractions();
  UtilsEvalInteractions();
  UtilsMathInteractions();
  UtilsRolesInteractions();
  UtilsDbInteractions();

  botInteractions.syncOnReady();

  bot.onReady.listen((ReadyEvent e) async {
    print('Ready!');
  });
}
