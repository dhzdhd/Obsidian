import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constants.dart';
import '../../utils/constraints.dart';
import '../../utils/database.dart';
import '../../utils/embed.dart';

class ModLogInteractions {
  ModLogInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'log',
        'Log group of commands.',
        [
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'assign',
            '<MOD ONLY> Convert a channel to a log channel.',
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
      ))
      ..registerButtonHandler('delete-log', deleteLogButtonHandler);
  }

  Future<void> createLogSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge(hidden: true);
    var channel = event.interaction.resolved?.channels.first;

    if (!(await checkForMod(event))) {
      await deleteMessageWithTimer(
        message: await event.sendFollowup(
          MessageBuilder.embed(errorEmbed(
              'You do not have the permissions to use this command!',
              event.interaction.userAuthor)),
        ),
      );
      return;
    }

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }

    var response = await LogDatabase.add(
        event.interaction.guild?.id.id as int, channel?.id.id as int);

    if (response) {
      await deleteMessageWithTimer(
          message: await event.sendFollowup(MessageBuilder.embed(
        successEmbed(
          'Successfully added the log channel data in the database!',
          event.interaction.userAuthor,
        ),
      )));
    } else {
      await deleteMessageWithTimer(
          message: await event.sendFollowup(MessageBuilder.embed(
        errorEmbed(
          'Error in adding the log channel data to the database!',
          event.interaction.userAuthor,
        ),
      )));
    }
  }

  Future<void> deleteLogSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge(hidden: true);

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }

    await event.sendFollowup(
      MessageBuilder.embed(EmbedBuilder()
        ..title = 'Are you sure you want to delete the log channel?'
        ..color = Colors.AUDIT_COLORS['mod']
        ..timestamp = DateTime.now()
        ..addFooter((footer) {
          footer.text =
              'Requested by ${event.interaction.userAuthor?.username}';
          footer.iconUrl = event.interaction.userAuthor?.avatarURL();
        })),
    );

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(ButtonBuilder('Yes', 'delete-log', ComponentStyle.danger));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
  }

  Future<void> deleteLogButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge(hidden: true);
    await event.interaction.message!.delete();

    final response = await LogDatabase.delete(event.interaction.guild!.id.id);

    if (response) {
      await event.respond(
        MessageBuilder.embed(successEmbed(
          'Successfully deleted the log channel data from database!',
          event.interaction.userAuthor,
        )),
        hidden: true,
      );
    } else {
      await deleteMessageWithTimer(
          message: await event.sendFollowup(
        MessageBuilder.embed(errorEmbed(
          'Error in deleting the log channel data from the database!\n A log channel may not exist in this server!',
          event.interaction.userAuthor,
        )),
      ));
    }

    final componentMessageBuilder = ComponentMessageBuilder();
    componentMessageBuilder.addComponentRow(ComponentRowBuilder());
    await event.sendFollowup(componentMessageBuilder);
  }
}
