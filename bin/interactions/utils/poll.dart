import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';

class UtilsPollInteractions {
  static const EMPTY_BAR = '▒';
  static const FILLED_BAR = '█';
  late EmbedBuilder staticPollEmbed;

  var userChoiceMap = {};
  var optionPercentMap = {};

  UtilsPollInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'poll',
        'Start a poll.',
        [
          CommandOptionBuilder(
            CommandOptionType.string,
            'title',
            'Title of the poll.',
            required: true,
          ),
          CommandOptionBuilder(
            CommandOptionType.string,
            'options',
            'Options for poll as comma separated strings. Max - 5',
            required: true,
          ),
          CommandOptionBuilder(
            CommandOptionType.boolean,
            'restrict',
            'Restrict multiple choices.',
            required: true,
          ),
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

  Future<void> buttonOption1(ButtonInteractionEvent event) async {
    await event.acknowledge();
    var pollEmbed = staticPollEmbed;

    await event.editOriginalResponse(MessageBuilder.embed(pollEmbed));

    await event.interaction.message?.edit(MessageBuilder.embed(pollEmbed));
  }

  Future<void> buttonOption2(ButtonInteractionEvent event) async {}

  Future<void> buttonOption3(ButtonInteractionEvent event) async {}

  Future<void> buttonOption4(ButtonInteractionEvent event) async {}

  Future<void> buttonOption5(ButtonInteractionEvent event) async {}

  Future<void> buttonOptionDeselect(ButtonInteractionEvent event) async {}

  Future<void> buttonOptionCancel(ButtonInteractionEvent event) async {}

  Future<void> pollSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final title = event.getArg('title').value;
    final options = event.getArg('options').value.toString().split(',');
    final restrict = event.getArg('restrict').value;
    print(restrict.runtimeType.toString());

    staticPollEmbed = EmbedBuilder()
      ..title = ':bar_chart: Poll: **$title**'
      ..color = DiscordColor.blue
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    var pollEmbed = staticPollEmbed;

    options.forEach((element) {
      pollEmbed.addField(
        name: '${(options.indexOf(element) + 1)}) $element',
        content: '${EMPTY_BAR * 20}| 0% (0)',
      );
    });

    await event.sendFollowup(MessageBuilder.embed(pollEmbed));

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder();

    for (var _ = 0; _ < options.length; _++) {
      componentRow.addComponent(ButtonBuilder(
          '${(_ + 1).toString()}', 'pollOption$_', ComponentStyle.primary));

      optionPercentMap[_ + 1] = 0;
    }

    componentRow
      ..addComponent(
          ButtonBuilder('Deselect', 'pollDeselect', ComponentStyle.secondary))
      ..addComponent(
          ButtonBuilder('Cancel', 'pollCancel', ComponentStyle.danger));

    componentMessageBuilder.addComponentRow(componentRow);
    await event.respond(componentMessageBuilder);
  }
}
