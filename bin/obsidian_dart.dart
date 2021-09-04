import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'interactions/fun/basic.dart';
import 'interactions/fun/youtube.dart';
import 'utils/constants.dart' show Tokens;

late Nyxx bot;

void main() async {
  Tokens.loadEnv();

  bot = Nyxx(
    Tokens.BOT_TOKEN,
    GatewayIntents.all,
  );

  Interactions(bot)
    // Fun commands
    ..registerSlashCommand(SlashCommandBuilder(
      'avatar',
      'Shows the user profile picture/gif.',
      [
        CommandOptionBuilder(CommandOptionType.user, 'user', 'A server member.')
      ],
    )..registerHandler(avatarSlashCommand))
    ..registerSlashCommand(SlashCommandBuilder('roll', 'Roll a die.', [])
      ..registerHandler(rollSlashCommand))
    ..registerSlashCommand(SlashCommandBuilder('flip', 'Flip a coin.', [])
      ..registerHandler(flipSlashCommand))
    ..registerSlashCommand(
        SlashCommandBuilder('wolfram', 'Wolfram group of commands.', [
      CommandOptionBuilder(CommandOptionType.subCommand, 'short',
          'Retrieves short answer for the question',
          options: [
            CommandOptionBuilder(CommandOptionType.string, 'query',
                'The query to ask to the Wolfram API.',
                required: true)
          ])
    ]))
    ..registerSlashCommand(
        SlashCommandBuilder('youtube', 'Search for a youtube video.', [
      CommandOptionBuilder(CommandOptionType.string, 'query', 'The video name.',
          required: true)
    ])
          ..registerHandler(ytSlashCommand))
    ..registerMultiselectHandler('youtube', ytOptionHandler)

    // Mod commands
    ..registerSlashCommand(SlashCommandBuilder(
        'warn', 'Warns user with reason', [
      CommandOptionBuilder(CommandOptionType.user, 'user', 'A server member')
    ]))

    // Sync
    ..syncOnReady();

  bot.onReady.listen((ReadyEvent e) async {
    print('Ready!');
    bot.setPresence(PresenceBuilder.of(
        status: UserStatus.online,
        activity: ActivityBuilder(
          '/info',
          ActivityType.listening,
        )));
  });
}
