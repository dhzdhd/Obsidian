import 'package:dio/dio.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/embed.dart';

class FunDictInteractions {
  static const DICT_URL = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
  static const URBAN_URL = 'https://api.urbandictionary.com/v0/define?term=';

  FunDictInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'dictionary',
      'Get the definition of the given word.',
      [
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'oxford',
          'The oxford dictionary.',
          options: [
            CommandOptionBuilder(
              CommandOptionType.string,
              'word',
              'The word whose definition you want to get.',
              required: true,
            )
          ],
        )..registerHandler(dictOxfordSlashCommand),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'urban',
          'The urban dictionary.',
          options: [
            CommandOptionBuilder(
              CommandOptionType.string,
              'word',
              'The word whose definition you want to get.',
              required: true,
            )
          ],
        )..registerHandler(dictUrbanSlashCommand)
      ],
    ));
  }

  EmbedBuilder dictEmbed(
      IUser author, String title, String type, String def, String ex) {
    return EmbedBuilder()
      ..title = '$type Dictionary: $title'
      ..description = '''
        **Definition:**\n$def\n
        **Example:**\n$ex
        '''
      ..color = DiscordColor.dartBlue
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${author.username}';
        footer.iconUrl = author.avatarURL();
      });
  }

  Future<void> dictOxfordSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final String word = event.getArg('word').value.trim();
    final author = event.interaction.userAuthor!;
    late final Response<dynamic> response;

    try {
      response = await dio.get('$DICT_URL${word.replaceAll(' ', '+')}');
    } on DioError catch (_) {
      await deleteMessageWithTimer(
        message: await event.sendFollowup(MessageBuilder.embed(errorEmbed(
          'The API could not understand the query!\nPlease try again with a different word.',
          author,
        ))),
      );
      return;
    }

    final Map raw = response.data[0]['meanings'][0]['definitions'][0];
    final def = raw['definition'];
    final ex =
        raw.keys.contains('example') ? raw['example'] : 'No examples found.';

    await event.respond(
      MessageBuilder.embed(dictEmbed(author, word, 'Oxford', def, ex)),
    );
  }

  Future<void> dictUrbanSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final word = event.getArg('word').value.toString().trim();
    final author = event.interaction.userAuthor!;
    final response = await dio.get('$URBAN_URL${word.replaceAll(' ', '+')}');

    late final String def, ex;
    try {
      final Map raw = response.data['list'][0];
      def = raw['definition'].replaceAll('[', '').replaceAll(']', '');
      ex = raw['example'].replaceAll('[', '').replaceAll(']', '');
    } on Error catch (_) {
      await deleteMessageWithTimer(
        message: await event.sendFollowup(MessageBuilder.embed(errorEmbed(
          'The API could not understand the query!\nPlease try again with a different word.',
          author,
        ))),
      );
      return;
    }

    await event.respond(
      MessageBuilder.embed(dictEmbed(author, word, 'Urban', def, ex)),
    );
  }
}
