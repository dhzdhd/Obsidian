import 'package:dio/dio.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';
import 'interactions/fun/basic.dart';
import 'interactions/fun/dict.dart';
import 'interactions/fun/movie.dart';
import 'interactions/fun/music.dart';
import 'interactions/fun/wolfram.dart';
import 'interactions/fun/xkcd.dart';
import 'interactions/fun/youtube.dart';
import 'interactions/mod/clone.dart';
import 'interactions/mod/dm.dart';
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
// import 'interactions/utils/poll.dart';
import 'plugins/logging.dart';
import 'utils/constants.dart' show Tokens;
import 'utils/database.dart' show initDatabase;
import 'interactions/utils/roles.dart';

late INyxxWebsocket bot;
late IInteractions botInteractions;
late Dio dio;
late ICluster cluster;

void main() async {
  Tokens.loadEnv();
  initDatabase();
  await CustomLogging.initLogFile();
  dio = Dio();

  bot = NyxxFactory.createNyxxWebsocket(
    Tokens.botToken,
    GatewayIntents.all,
    options: ClientOptions(
      initialPresence: PresenceBuilder.of(
        status: UserStatus.online,
        activity: ActivityBuilder("your DM's 👀", ActivityType.listening,
            url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
      ),
    ),
  )
    ..registerPlugin(CustomLogging())
    ..registerPlugin(CliIntegration())
    ..registerPlugin(IgnoreExceptions())
    ..connect();

  botInteractions = IInteractions.create(WebsocketInteractionBackend(bot));

  cluster = ICluster.createCluster(bot, Snowflake(Tokens.botId));
  await cluster.addNode(NodeOptions(
    host: '127.0.0.1',
    port: 2333,
  ));

  // Fun interactions
  FunBasicInteractions();
  FunDictInteractions();
  FunWolframInteractions();
  FunYoutubeInteractions();
  FunMovieInteractions();
  FunMusicInteractions();
  FunXkcdInteractions();

  // Mod interactions
  ModCloneInteractions();
  ModDmInteractions();
  ModEventsInteractions();
  ModEssentialInteractions();
  ModMuteInteractions();
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

  bot.eventsWs.onReady.listen((IReadyEvent _) async {
    print('Ready!');
  });
}
