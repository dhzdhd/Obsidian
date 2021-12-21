import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constraints.dart';
import '../../utils/database.dart';
import '../../utils/embed.dart';

// TODO : confirm button for deleting data

class UtilsDbInteractions {
  UtilsDbInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'database',
      'Database commands.',
      [
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'view-users',
          '<BOT OWNER ONLY> View all user data.',
          options: [
            CommandOptionBuilder(
              CommandOptionType.integer,
              'amount',
              'Amount of records to be retrieved.',
            )
          ],
        )..registerHandler(viewUserDataSlashCommand),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'delete-users',
          '<BOT OWNER ONLY> Delete all user data',
        )..registerHandler(deleteUserDataSlashCommand),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'view-log',
          '<BOT OWNER ONLY> View all log channel data.',
          options: [
            CommandOptionBuilder(
              CommandOptionType.integer,
              'amount',
              'Amount of records to be retrieved.',
            )
          ],
        )..registerHandler(viewLogDataSlashCommand),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'delete-log',
          '<BOT OWNER ONLY> Delete all log channel data',
        )..registerHandler(deleteLogDataSlashCommand),
      ],
    ));
  }

  Future<void> viewUserDataSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();
    late var amount;

    try {
      amount = event.getArg('amount').value;
    } catch (err) {
      amount = null;
    }

    if (!(await checkForOwner(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }

    var message = '';
    var response = await UserDatabase.fetch(amount: amount);
    response.forEach((element) {
      message += '$element\n';
    });

    await event.respond(MessageBuilder.content(message));
  }

  Future<void> deleteUserDataSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    if (!(await checkForOwner(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }

    var response = await UserDatabase.delete();

    if (response) {
      await event.respond(MessageBuilder.embed(successEmbed(
          'Successfully deleted user records', event.interaction.userAuthor)));
    } else {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Error in deleting user records!', event.interaction.userAuthor)));
    }
  }

  Future<void> viewLogDataSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();
    late var amount;

    try {
      amount = event.getArg('amount').value;
    } catch (err) {
      amount = null;
    }

    if (!(await checkForOwner(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }

    var message = '';
    var response = await LogDatabase.fetch(amount: amount);
    response.forEach((element) {
      message += '$element\n';
    });

    await event.respond(MessageBuilder.content(message));
  }

  Future<void> deleteLogDataSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    if (!(await checkForOwner(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }

    var response = await LogDatabase.delete();

    if (response) {
      await event.respond(
        MessageBuilder.embed(successEmbed(
            'Successfully deleted log channel records',
            event.interaction.userAuthor)),
      );
    } else {
      await event.respond(
        MessageBuilder.embed(errorEmbed(
            'Error in deleting log channel records!',
            event.interaction.userAuthor)),
      );
    }
  }
}
