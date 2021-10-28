import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constants.dart';

class ModCloneInteractions {
  var cloneDict = {};

  ModCloneInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'clone',
        'Clone a channel and delete the original.',
        [
          CommandOptionBuilder(
            CommandOptionType.channel,
            'channel',
            'The channel to be cloned.',
            channelTypes: [ChannelType.text],
          )
        ],
      )..registerHandler(cloneSlashCommand))
      ..registerButtonHandler('clone-accept', cloneButtonAcceptHandler)
      ..registerButtonHandler('clone-reject', cloneButtonRejectHandler);
  }

  Future<void> cloneSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge(hidden: true);

    final channel = event.getArg('channel').value as TextGuildChannel? ??
        event.interaction.channel.getFromCache() as TextGuildChannel;
    final author = event.interaction.userAuthor!;

    final message = await event.sendFollowup(MessageBuilder.embed(
      EmbedBuilder()
        ..title = 'Clone ${channel.name}'
        ..description = 'Are you sure you want to clone **${channel.name}**?'
        ..color = Colors.AUDIT_COLORS['mod']
        ..timestamp = DateTime.now()
        ..addFooter((footer) {
          footer.text = 'Message sent by ${author.username}';
          footer.iconUrl = author.avatarURL();
        }),
    ));

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(
          ButtonBuilder('Yes', 'clone-accept', ComponentStyle.success))
      ..addComponent(
          ButtonBuilder('No', 'clone-reject', ComponentStyle.danger));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);

    cloneDict[message.id.id] = channel;
  }

  Future<void> cloneButtonAcceptHandler(ButtonInteractionEvent event) async {
    await event.acknowledge(hidden: true);

    final TextGuildChannel channel =
        cloneDict[event.interaction.message!.id.id];

    // final perms = channel.permissionOverrides;
    // final name = channel.name;
    // final topic = channel.topic;
    // final position = channel.position;
    final category = channel.parentChannel?.getFromCache()?.id;
    // final nsfw = channel.isNsfw;
    final overrides = PermissionOverrideBuilder.of(SnowflakeEntity(channel.id));

    await channel.delete();

    await event.interaction.guild!.getFromCache()!.createChannel(
          ChannelBuilder()
            ..type = ChannelType.text
            ..name = channel.name
            ..topic = channel.topic
            ..position = channel.position
            ..parentChannel = SnowflakeEntity(category!)
            ..nsfw = channel.isNsfw
            ..overrides = [overrides],
        );
  }

  Future<void> cloneButtonRejectHandler(ButtonInteractionEvent event) async {
    await event.acknowledge(hidden: true);

    await event.interaction.message!.delete();
  }
}
