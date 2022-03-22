import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

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
      ..registerButtonHandler('delete-log-button', deleteLogButtonHandler);
  }

  Future<void> createLogSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge(hidden: true);
    var channel = event.interaction.resolved!.channels.first;

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }

    final response =
        await LogDatabase.add(event.interaction.guild!.id.id, channel.id.id);

    if (response) {
      await event.respond(MessageBuilder.embed(
        successEmbed(
          'Successfully added the log channel data to the database!',
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

  Future<void> deleteLogSlashCommand(
      ISlashCommandInteractionEvent event) async {
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
        ..color = Colors.auditColors['mod']
        ..timestamp = DateTime.now()
        ..addFooter((footer) {
          footer.text =
              'Requested by ${event.interaction.userAuthor?.username}';
          footer.iconUrl = event.interaction.userAuthor?.avatarURL();
        })),
    );

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(
          ButtonBuilder('Yes', 'delete-log-button', ButtonStyle.danger));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
  }

  Future<void> deleteLogButtonHandler(IButtonInteractionEvent event) async {
    await event.acknowledge(hidden: true);

    final response = await LogDatabase.delete(event.interaction.guild!.id.id);

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

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(ButtonBuilder(
        'Done!',
        'delete-log-button',
        ButtonStyle.success,
        disabled: true,
      ));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.editFollowup(
      event.interaction.message!.id,
      componentMessageBuilder,
    );
  }
}
