import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constants.dart';
import '../../utils/constraints.dart';
import '../../utils/embed.dart';

class ModCloneInteractions {
  var cloneDict = <int, TextGuildChannel>{};

  ModCloneInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'clone',
        '<MOD ONLY> Clone a channel and delete the original.',
        [
          // CommandOptionBuilder(
          //   CommandOptionType.channel,
          //   'channel',
          //   'The channel to be cloned.',
          //   channelTypes: [ChannelType.text],
          // )
        ],
      )..registerHandler(cloneSlashCommand))
      ..registerButtonHandler('clone-accept', cloneButtonAcceptHandler)
      ..registerButtonHandler('clone-reject', cloneButtonRejectHandler);
  }

  Future<void> cloneSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }

    // ! Add support for channel args
    final channel =
        event.interaction.channel.getFromCache() as TextGuildChannel;
    final author = event.interaction.userAuthor!;

    final message = await event.sendFollowup(MessageBuilder.embed(
      EmbedBuilder()
        ..title = 'Clone channel'
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

    if (!(await checkForMod(event))) {
      await event.interaction.userAuthor
          ?.sendMessage(MessageBuilder.embed(errorEmbed(
        'You do not have the permissions to use this button!',
        event.interaction.userAuthor,
      )));
      return;
    }

    final channel = cloneDict[event.interaction.message!.id.id]!;
    cloneDict.remove(event.interaction.message!.id.id);

    final overrides = channel.permissionOverrides.map((element) {
      return PermissionOverrideBuilder.of(SnowflakeEntity(element.id));
    }).toList();

    await channel.delete();

    await event.interaction.guild?.getFromCache()?.createChannel(
          ChannelBuilder()
            ..type = ChannelType.text
            ..name = channel.name
            ..topic = channel.topic
            ..position = channel.position
            ..parentChannel =
                SnowflakeEntity(channel.parentChannel!.getFromCache()!.id)
            // ..overrides = overrides
            ..nsfw = channel.isNsfw,
        );
  }

  Future<void> cloneButtonRejectHandler(ButtonInteractionEvent event) async {
    await event.acknowledge(hidden: true);

    if (!(await checkForMod(event))) {
      await event.interaction.userAuthor
          ?.sendMessage(MessageBuilder.embed(errorEmbed(
        'You do not have the permissions to use this button!',
        event.interaction.userAuthor,
      )));
      return;
    }

    await event.interaction.message!.delete();
  }
}
