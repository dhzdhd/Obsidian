import 'package:dio/dio.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:nyxx_lavalink/lavalink.dart';
import 'interactions/fun/basic.dart';
import 'interactions/fun/dict.dart';
import 'interactions/fun/movie.dart';
import 'interactions/fun/music.dart';
import 'interactions/fun/wolfram.dart';
import 'interactions/fun/youtube.dart';
import 'interactions/mod/clone.dart';
import 'interactions/mod/essential.dart';
import 'interactions/mod/events.dart';
import 'interactions/mod/log.dart';
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
late Dio dio;
late Cluster cluster;

void main() async {
  Tokens.loadEnv();
  initDatabase();
  dio = Dio();

  bot = Nyxx(Tokens.BOT_TOKEN, GatewayIntents.all,
      options: ClientOptions(
        initialPresence: PresenceBuilder.of(
          status: UserStatus.online,
          activity: ActivityBuilder("your DM's 👀", ActivityType.listening,
              url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
        ),
      ));

  botInteractions = Interactions(bot);

  cluster = Cluster(bot, Snowflake(Tokens.BOT_ID));
  await cluster.addNode(NodeOptions(
    host: 'localhost',
    port: 2333,
  ));

  // Fun interactions
  FunBasicInteractions();
  FunDictInteractions();
  FunWolframInteractions();
  FunYoutubeInteractions();
  FunMovieInteractions();
  FunMusicInteractions();

  // Mod interactions
  ModCloneInteractions();
  ModEventsInteractions();
  ModEssentialInteractions();
  // ModMuteInteractions();
  ModWarnBanInteractions();
  ModVcInteractions();
  ModLogInteractions();

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
