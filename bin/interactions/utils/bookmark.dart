import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx/nyxx.dart';

import '../../obsidian_dart.dart' show botInteractions;

class UtilsBookmarkInteractions {
  late final EmbedBuilder bookmarkEmbed;

  UtilsBookmarkInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'bookmark',
        'Bookmark a message.',
        [
          CommandOptionBuilder(
            CommandOptionType.string,
            'id',
            'Message ID.',
            required: true,
          )
        ],
      )..registerHandler(bookmarkSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder(
        'Bookmark',
        null,
        [],
        type: SlashCommandType.message,
      )..registerHandler(bookmarkSlashCommand))
      ..registerButtonHandler('add-bm-button', addButtonHandler)
      ..registerButtonHandler('delete-bm-button', deleteButtonHandler);
  }

  Future<void> bookmarkSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    late final IMessage? message;

    if (event.interaction.type == SlashCommandType.chat.value) {
      final id = int.parse(event.getArg('id').value.toString());
      message = await (await event.interaction.channel.getOrDownload())
          .fetchMessage(id.toSnowflake());
    } else {
      message = (await event.interaction.channel.getOrDownload())
          .getMessage(event.interaction.targetId!);
    }

    bookmarkEmbed = EmbedBuilder()
      ..title = 'Bookmarked message'
      ..description = message?.url
      ..color = DiscordColor.azure
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    await event.sendFollowup(MessageBuilder.embed(bookmarkEmbed));

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(ButtonBuilder(
          'Bookmark this ', 'add-bm-button', ComponentStyle.success))
      ..addComponent(
          ButtonBuilder('Delete', 'delete-bm-button', ComponentStyle.danger));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
  }

  Future<void> addButtonHandler(IButtonInteractionEvent event) async {
    await event.acknowledge();
    final author = event.interaction.userAuthor;

    await author?.sendMessage(MessageBuilder.embed(bookmarkEmbed)) ??
        await event.respond(
          MessageBuilder.content(
            "Your DM's are closed! The bookmarked message cannot be sent!",
          ),
          hidden: true,
        );
  }

  Future<void> deleteButtonHandler(IButtonInteractionEvent event) async {
    await event.acknowledge();

    await event.deleteOriginalResponse();
  }
}
