import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'interactions/fun/basic.dart';
import 'interactions/fun/wolfram.dart';
import 'interactions/fun/youtube.dart';
import 'interactions/mod/common.dart';
import 'interactions/utils/bookmark.dart';
import 'interactions/utils/common.dart';
import 'package:logging/logging.dart' show Logger, Level;
import 'interactions/utils/poll.dart';
import 'utils/constants.dart' show Tokens;
import 'utils/database.dart' show Database;

late Nyxx bot;
late Interactions botInteractions;

void main() async {
  Tokens.loadEnv();
  Database();

  bot = Nyxx(
    Tokens.BOT_TOKEN,
    GatewayIntents.all,
  );

  botInteractions = Interactions(bot);

  // Fun interactions
  FunBasicInteractions();
  FunWolframInteractions();
  FunYoutubeInteractions();

  // Mod interactions
  ModCommonInteractions();

  // Utils interactions
  UtilsCommonInteractions();
  UtilsBookmarkInteractions();
  UtilsPollInteractions();

  botInteractions.syncOnReady();

  bot.onReady.listen((ReadyEvent e) async {
    print('Ready!');
  });

  bot.onDisconnect.listen((DisconnectEvent event) async {
    await Database.connection.close();
  });
}
