import 'package:nyxx_interactions/interactions.dart';
import 'package:nyxx/nyxx.dart';

import '../../obsidian_dart.dart' show botInteractions;

class UtilsBookmarkInteractions {
  UtilsBookmarkInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
          'bookmark',
          'Bookmark a message.',
          [CommandOptionBuilder(CommandOptionType.string, 'id', 'Message ID.')])
        ..registerHandler(bookmarkSlashCommand))
      ..registerButtonHandler('bookmark', bookmarkOptionHandler)
      ..registerButtonHandler('bookmark-delete', deleteOptionHandler);
  }

  Future<void> bookmarkOptionHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();

    // await message.delete();
    print('hmm');
  }

  Future<void> deleteOptionHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();

    await event.deleteOriginalResponse();
  }

  Future<void> bookmarkSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    late Message? message;

    final id = int.tryParse(event.getArg('id').value);
    print(id);
    if (id == null) {
      event.getOriginalResponse().then((value) => print(value.content));
    } else {
      message = await event.interaction.channel
          .getFromCache()
          ?.fetchMessage(id.toSnowflake());
    }

    final bookmarkEmbed = EmbedBuilder()
      ..title = 'Bookmarked message'
      ..description = message?.url
      ..color = DiscordColor.azure
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    await event.sendFollowup(MessageBuilder.embed(bookmarkEmbed));

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(ButtonBuilder(
          ':dart: Bookmark this ', 'bookmark', ComponentStyle.success))
      ..addComponent(
          ButtonBuilder(':x: Delete', 'bookmark', ComponentStyle.danger));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
  }
}
