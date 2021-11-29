import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constraints.dart';
import '../../utils/database.dart';
import '../../utils/embed.dart';

class ModLogInteractions {
  ModLogInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'log',
      'Log group of commands.',
      [
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'create',
          '<MOD ONLY> Create a new log channel.',
          options: [
            CommandOptionBuilder(
              CommandOptionType.channel,
              'channel',
              'Channel to assign to logging.',
              required: true,
              channelTypes: [ChannelType.text],
            )
          ],
        )..registerHandler(createLogSlashCommand),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'delete',
          '<MOD ONLY> Delete an existing log channel.',
        )..registerHandler(deleteLogSlashCommand)
      ],
    ));
  }

  Future<void> createLogSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    var channel = event.interaction.resolved?.channels.first;

    if (!(channel?.type == ChannelType.text)) {
      await event.respond(
        MessageBuilder.embed(
          errorEmbed('The given channel cannot be used as a log channel!',
              event.interaction.userAuthor),
        ),
      );
      return;
    }

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.content(
          'You do not have the permissions to use this command!'));
      return;
    }

    var response = await LogDatabase.add(
        event.interaction.guild?.id.id as int, channel?.id.id as int);

    if (response) {
      await event.respond(MessageBuilder.embed(
        successEmbed(
          'Successfully added the log channel data in the database!',
          event.interaction.userAuthor,
        ),
      ));
    } else {
      await event.respond(MessageBuilder.embed(
        errorEmbed(
          'Error in adding the log channel data to the database!',
          event.interaction.userAuthor,
        ),
      ));
    }
  }

  Future<void> deleteLogSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.content(
          'You do not have the permissions to use this command!'));
      return;
    }

    var response =
        await LogDatabase.delete(event.interaction.guild?.id.id as int);

    if (response) {
      await event.respond(
        MessageBuilder.embed(successEmbed(
          'Successfully deleted the log channel data from database!',
          event.interaction.userAuthor,
        )),
      );
    } else {
      await event.respond(
        MessageBuilder.embed(errorEmbed(
          'Error in deleting the log channel data from the database!\n A log channel may not exist in this server!',
          event.interaction.userAuthor,
        )),
      );
    }
  }
}
