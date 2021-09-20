import 'package:nyxx_interactions/interactions.dart';
import 'package:nyxx/nyxx.dart';

import '../../obsidian_dart.dart' show botInteractions;

class UtilsBookmarkInteractions {
  late Message? message;
  late EmbedBuilder bookmarkEmbed;

  UtilsBookmarkInteractions() {
    botInteractions
      ..registerSlashCommand(
          SlashCommandBuilder('bookmark', 'Bookmark a message.', [
        CommandOptionBuilder(
          CommandOptionType.string,
          'id',
          'Message ID.',
          required: true,
        )
      ])
            ..registerHandler(bookmarkSlashCommand))
      ..registerButtonHandler('addBookmark', addOptionHandler)
      ..registerButtonHandler('deleteBookmark', deleteOptionHandler);
  }

  Future<void> addOptionHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();
    final author = event.interaction.userAuthor;

    await author?.sendMessage(MessageBuilder.embed(bookmarkEmbed)) ??
        await event.respond(
          MessageBuilder.content(
              "Your DM's are closed! I cannot send the bookmarke message to you!"),
          hidden: true,
        );
  }

  Future<void> deleteOptionHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();

    await event.deleteOriginalResponse();
  }

  Future<void> bookmarkSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final id = int.tryParse(event.getArg('id').value);

    if (id == null) {
      await event.respond(MessageBuilder.content('Enter a valid message ID!'));
      return;
    } else {
      message = await event.interaction.channel
          .getFromCache()
          ?.fetchMessage(id.toSnowflake());
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
          'Bookmark this ', 'addBookmark', ComponentStyle.success))
      ..addComponent(
          ButtonBuilder('Delete', 'deleteBookmark', ComponentStyle.danger));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
  }
}
