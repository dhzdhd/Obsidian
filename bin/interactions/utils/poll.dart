import 'package:dio/dio.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';

class UtilsPollInteractions {
  UtilsPollInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'poll',
        'Start a poll.',
        [
          CommandOptionBuilder(
              CommandOptionType.string, 'title', 'Title of the poll.'),
          CommandOptionBuilder(CommandOptionType.string, 'options',
              'Options for poll as comma separated strings.')
        ],
      )..registerHandler(pollSlashCommand))
      ..registerButtonHandler('pollOption1', buttonOption1)
      ..registerButtonHandler('pollOption2', buttonOption2)
      ..registerButtonHandler('pollOption3', buttonOption3)
      ..registerButtonHandler('pollOption4', buttonOption4)
      ..registerButtonHandler('pollOption5', buttonOption5)
      ..registerButtonHandler('pollDeselect', buttonOptionDeselect)
      ..registerButtonHandler('pollCancel', buttonOptionCancel);
  }

  Future<void> buttonOption1(ButtonInteractionEvent event) async {}

  Future<void> buttonOption2(ButtonInteractionEvent event) async {}

  Future<void> buttonOption3(ButtonInteractionEvent event) async {}

  Future<void> buttonOption4(ButtonInteractionEvent event) async {}

  Future<void> buttonOption5(ButtonInteractionEvent event) async {}

  Future<void> buttonOptionDeselect(ButtonInteractionEvent event) async {}

  Future<void> buttonOptionCancel(ButtonInteractionEvent event) async {}

  Future<void> pollSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final options = event.interaction.options;
    final pollOptionList = options.elementAt(1).toString().split(',');

    var pollEmbed = EmbedBuilder()
      ..title = 'Poll: **${options.first.value}**'
      ..color = DiscordColor.blue
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    await event.sendFollowup(MessageBuilder.embed(pollEmbed));

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder();

    componentRow
      ..addComponent(
          ButtonBuilder('Deselect', 'pollDeselect', ComponentStyle.secondary))
      ..addComponent(
          ButtonBuilder('Cancel', 'pollCancel', ComponentStyle.danger));

    for (var _ = 0; _ < pollOptionList.length; _++) {
      componentRow.addComponent(
          ButtonBuilder(_.toString(), 'pollOption$_', ComponentStyle.primary));
    }

    componentMessageBuilder.addComponentRow(componentRow);
    await event.respond(componentMessageBuilder);
  }
}
