import 'dart:async';

import 'package:dio/dio.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/embed.dart';

const BASE_URL = 'https://xkcd.com';

class FunXkcdInteractions {
  FunXkcdInteractions() {
    botInteractions.registerSlashCommand(
      SlashCommandBuilder(
        'xkcd',
        'XKCD group of commands.',
        [
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'latest',
            'Retrives lastest XKCD comic.',
          )..registerHandler(xkcdLatestSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'search',
            'Retrives XKCD comic.',
            options: [
              CommandOptionBuilder(
                  CommandOptionType.integer, 'comic', 'XKCD Comic number.',
                  required: true)
            ],
          )..registerHandler(xkcdComicSlashCommand),
        ],
      ),
    );
  }

  EmbedBuilder xkcdEmbed(ISlashCommandInteractionEvent event, String title,
      String desc, String imgUrl) {
    return EmbedBuilder()
      ..title = title
      ..description = desc
      ..color = DiscordColor.sapGreen
      ..timestamp = DateTime.now()
      ..imageUrl = imgUrl
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });
  }

  Future<dynamic> xkcdLatestComicInfo() async {
    late final Response response;
    try {
      response = await dio.get('$BASE_URL/info.0.json');
    } on DioError catch (err) {
      print(err);
    }
    return response.data;
  }

  Future<void> xkcdLatestSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final comicInfo = await xkcdLatestComicInfo();

    Timer.periodic(
      const Duration(minutes: 30),
      (_) => xkcdLatestComicInfo(),
    );

    final date =
        "${comicInfo['year']}/${comicInfo['month']}/${comicInfo['day']}";

    final embed = xkcdEmbed(
      event,
      "${comicInfo['safe_title']} (#${comicInfo['num']})",
      "${comicInfo['alt']}\n\nPublished On: $date",
      comicInfo['img'],
    );
    await event.respond(MessageBuilder.embed(embed));
  }

  Future<void> xkcdComicSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final comic = event.getArg('comic').value;

    late final Response response;
    try {
      response = await dio.get('$BASE_URL/$comic/info.0.json');
    } on DioError catch (err) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          '${err.response?.statusCode}: Could not retrieve xkcd comic #$comic',
          event.interaction.userAuthor)));
      return;
    }

    final comicInfo = response.data;
    final date =
        "${comicInfo['year']}/${comicInfo['month']}/${comicInfo['day']}";

    final embed = xkcdEmbed(
      event,
      "${comicInfo['safe_title']} (#${comicInfo['num']})",
      "${comicInfo['alt']}\n\nPublished On: $date",
      comicInfo['img'],
    );
    await event.respond(MessageBuilder.embed(embed));
  }
}
