import 'package:postgres/postgres.dart';

import '../../obsidian_dart.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:nyxx/nyxx.dart';

import '../../utils/constants.dart';
import '../../utils/database.dart';

class ModWarnBanInteractions {
  ModWarnBanInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'warn',
        'Warns user with reason.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member.',
              required: true),
          CommandOptionBuilder(
              CommandOptionType.string, 'reason', 'Reason for warn.',
              required: true)
        ],
      )..registerHandler(warnSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder(
        'ban',
        'Bans user with optional reason.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member',
              required: true),
          CommandOptionBuilder(
              CommandOptionType.string, 'reason', 'Reason for ban.')
        ],
      ));
  }

  Future<void> warnSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final user = event.interaction.resolved?.users.first;
    final reason = event.interaction.options.elementAt(1).value;

    final warnEmbed = EmbedBuilder()
      ..title = ':warning: Warned user: ${user?.username}'
      ..description = '**$reason**'
      ..color = Colors.AUDIT_COLORS['mod']
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    try {
      await Database.add(user?.id.id as int,
          event.interaction.guild?.id.id as int, 'warns', 1);
    } on PostgreSQLException catch (err) {
      print(err.toString());
    }

    await event.respond(MessageBuilder.embed(warnEmbed));
  }
}
