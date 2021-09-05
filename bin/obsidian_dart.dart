import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'interactions/fun/basic.dart';
import 'interactions/fun/youtube.dart';
import 'interactions/mod/moderation.dart';
import 'interactions/utils/bookmark.dart';
import 'interactions/utils/utilities.dart';
import 'utils/constants.dart' show Tokens;
import 'utils/database.dart' show Database;

late Nyxx bot;

void main() async {
  Tokens.loadEnv();
  Database();

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
      'warn',
      'Warns user with reason.',
      [
        CommandOptionBuilder(CommandOptionType.user, 'user', 'A server member.',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'reason', 'Reason for warn.')
      ],
    )..registerHandler(warnSlashCommand))
    ..registerSlashCommand(
        SlashCommandBuilder('mute', 'Mutes user for a certain time period.', [
      CommandOptionBuilder(CommandOptionType.user, 'user', 'A server member',
          required: true),
      CommandOptionBuilder(
          CommandOptionType.integer, 'time', 'Time period of mute.',
          required: true),
      CommandOptionBuilder(
          CommandOptionType.string, 'reason', 'Reason for mute.')
    ], permissions: [
      ICommandPermissionBuilder.role(
          PermissionsConstants.administrator.toSnowflake())
    ]))
    ..registerSlashCommand(
        SlashCommandBuilder('unmute', 'Unmutes muted user.', [
      CommandOptionBuilder(CommandOptionType.user, 'user', 'A server member',
          required: true)
    ]))
    ..registerSlashCommand(
        SlashCommandBuilder('ban', 'Bans user with optional reason.', [
      CommandOptionBuilder(CommandOptionType.user, 'user', 'A server member',
          required: true),
      CommandOptionBuilder(
          CommandOptionType.string, 'reason', 'Reason for ban.')
    ]))

    // Util commands
    ..registerSlashCommand(SlashCommandBuilder(
        'bookmark',
        'Bookmark a message.',
        [CommandOptionBuilder(CommandOptionType.string, 'id', 'Message ID.')])
      ..registerHandler(bookmarkSlashCommand))
    ..registerButtonHandler('bookmark', bookmarkOptionHandler)
    ..registerSlashCommand(
        SlashCommandBuilder('invite', 'Send bot invite link.', [])
          ..registerHandler(inviteBotSlashCommand))

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
