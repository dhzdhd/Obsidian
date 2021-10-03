import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constraints.dart';
import '../../utils/database.dart';
import '../../utils/embed.dart';

class UtilsDbInteractions {
  UtilsDbInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'database',
      'Database commands.',
      [
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'view',
          '|BOT OWNER ONLY| View all user data.',
          options: [
            CommandOptionBuilder(
              CommandOptionType.integer,
              'amount',
              'Amount to records to be retrieved.',
            )
          ],
        )..registerHandler(viewDataSlashCommand),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'delete',
          '|BOT OWNER ONLY| Delete all user data',
        )..registerHandler(deleteDataSlashCommand)
      ],
    ));
  }

  // FIXME:
  Future<void> viewDataSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    var amount = event.getArg('amount').value ?? 0;
    amount = amount.toString();

    if (!(await checkForOwner(event))) {
      await event.respond(MessageBuilder.content(
          'You do not have the permissions to use this command!'));
      return;
    }

    var response = await UserDatabase.viewAll(amount);
    await event.respond(MessageBuilder.content(response.toString()));
  }

  Future<void> deleteDataSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    if (!(await checkForOwner(event))) {
      await event.respond(MessageBuilder.content(
          'You do not have the permissions to use this command!'));
      return;
    }

    var response = await UserDatabase.deleteAll();

    if (response) {
      await event.respond(MessageBuilder.embed(successEmbed(
          'Successfully deleted user records', event.interaction.userAuthor)));
    } else {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Error in deleting user records!', event.interaction.userAuthor)));
    }
  }
}
