import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/embed.dart';

enum _OptionEnum { one, two, three, four, five }

class _EmbedData {
  EmbedBuilder embed;
  final Map<Snowflake, _OptionEnum> map;
  int total;

  _EmbedData({required this.embed, required this.map, required this.total});
}

class UtilsPollInteractions {
  static const emptyBar = '▒';
  static const filledBar = '█';
  Map<Snowflake, _EmbedData> embedMap = {};

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
            'Options for poll as comma separated strings. Maximum of 5 options allowed.',
            required: true,
          ),
        ],
      )..registerHandler(pollSlashCommand))
      ..registerButtonHandler('poll-button-1', buttonHandler1)
      ..registerButtonHandler('poll-button-2', buttonHandler2)
      ..registerButtonHandler('poll-button-3', buttonHandler3)
      ..registerButtonHandler('poll-button-4', buttonHandler4)
      ..registerButtonHandler('poll-button-5', buttonHandler5)
      ..registerButtonHandler('poll-button-deselect', deselectButtonHandler)
      ..registerButtonHandler('poll-button-cancel', cancelButtonHandler);
  }

  Future<void> pollSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final title = event.getArg('title').value.toString();
    final options = event.getArg('options').value.toString().split(',');

    if (options.length > 5) {
      await deleteMessageWithTimer(
          message: await event.sendFollowup(MessageBuilder.embed(errorEmbed(
        'Cannot enter more than 5 options!',
        event.interaction.userAuthor,
      ))));
      return;
    }

    final embed = EmbedBuilder()
      ..title = ':bar_chart: Poll: **$title**'
      ..color = DiscordColor.blue
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    for (var i = 0; i < options.length; i++) {
      embed.addField(
        name: '${i + 1}) ${options[i]}',
        content: '${emptyBar * 20}| 0% (0)',
      );
    }

    final message = await event.sendFollowup(MessageBuilder.embed(embed));

    embedMap[message.id] = _EmbedData(embed: embed, map: {}, total: 0);

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow1 = ComponentRowBuilder();
    final componentRow2 = ComponentRowBuilder();

    for (var i = 0; i < options.length; i++) {
      componentRow1.addComponent(ButtonBuilder(
          '${(i + 1)}', 'poll-button-${i + 1}', ButtonStyle.primary));
    }
    componentRow2
      ..addComponent(ButtonBuilder(
          'Deselect', 'poll-button-deselect', ButtonStyle.secondary))
      ..addComponent(
          ButtonBuilder('Cancel', 'poll-button-cancel', ButtonStyle.danger));

    componentMessageBuilder
      ..addComponentRow(componentRow1)
      ..addComponentRow(componentRow2);
    await event.respond(componentMessageBuilder);
  }

  void editEmbedContent(_EmbedData data) {
    for (var i = 0; i < data.embed.fields.length; i++) {
      final optionAmount = data.map.values
          .where((element) => element == _OptionEnum.values[i])
          .length;
      final percent = data.total != 0 ? (optionAmount / data.total) * 100 : 0;
      final barAmount = (percent / 5).round();
      data.embed.fields[i].content =
          '${filledBar * barAmount}${emptyBar * (20 - barAmount)} ${percent.toStringAsFixed(2)}% ($optionAmount)';
    }
  }

  void editEmbedMap(
      _OptionEnum option, _EmbedData data, IButtonInteractionEvent event) {
    if (data.map.containsKey(event.interaction.userAuthor!.id) &&
        data.map[event.interaction.userAuthor!.id] == option) {
      return;
    } else if (data.map.containsKey(event.interaction.userAuthor!.id) &&
        data.map[event.interaction.userAuthor!.id] != option) {
      data.total--;
      data.map.remove(event.interaction.userAuthor!.id);
    }

    data.total++;
    data.map[event.interaction.userAuthor!.id] = option;
  }

  Future<void> buttonHandler1(IButtonInteractionEvent event) async {
    await event.acknowledge();
    final data = embedMap[event.interaction.message!.id]!;

    editEmbedMap(_OptionEnum.one, data, event);
    editEmbedContent(data);
    await event.editOriginalResponse(MessageBuilder.embed(data.embed));
  }

  Future<void> buttonHandler2(IButtonInteractionEvent event) async {
    await event.acknowledge();
    final data = embedMap[event.interaction.message!.id]!;

    editEmbedMap(_OptionEnum.two, data, event);
    editEmbedContent(data);
    await event.editOriginalResponse(MessageBuilder.embed(data.embed));
  }

  Future<void> buttonHandler3(IButtonInteractionEvent event) async {
    await event.acknowledge();
    final data = embedMap[event.interaction.message!.id]!;

    editEmbedMap(_OptionEnum.three, data, event);
    editEmbedContent(data);
    await event.editOriginalResponse(MessageBuilder.embed(data.embed));
  }

  Future<void> buttonHandler4(IButtonInteractionEvent event) async {
    await event.acknowledge();
    final data = embedMap[event.interaction.message!.id]!;

    editEmbedMap(_OptionEnum.four, data, event);
    editEmbedContent(data);
    await event.editOriginalResponse(MessageBuilder.embed(data.embed));
  }

  Future<void> buttonHandler5(IButtonInteractionEvent event) async {
    await event.acknowledge();
    final data = embedMap[event.interaction.message!.id]!;

    editEmbedMap(_OptionEnum.five, data, event);
    editEmbedContent(data);
    await event.editOriginalResponse(MessageBuilder.embed(data.embed));
  }

  Future<void> deselectButtonHandler(IButtonInteractionEvent event) async {
    await event.acknowledge();
    final data = embedMap[event.interaction.message!.id]!;

    data.total--;
    data.map.remove(event.interaction.userAuthor!.id);

    editEmbedContent(data);
    await event.editOriginalResponse(MessageBuilder.embed(data.embed));
  }

  Future<void> cancelButtonHandler(IButtonInteractionEvent event) async {
    await event.acknowledge();
    embedMap.remove(event.interaction.message!.id);
    await event.deleteOriginalResponse();
  }
}
