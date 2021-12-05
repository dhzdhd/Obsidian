import 'dart:async';

import 'package:dio/dio.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constants.dart';
import '../../utils/embed.dart';

class FunXkcdInteractions {
  final BASE_URL = 'https://xkcd.com';

  FunXkcdInteractions() {
    botInteractions.registerSlashCommand(
      SlashCommandBuilder(
        'xkcd',
        'XKCD group of commands.',
        [
          CommandOptionBuilder(CommandOptionType.subCommand, 'latest',
              'Retrives lastest XKCD comic.')
            ..registerHandler(xkcdLatestSlashCommand),
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

  EmbedBuilder xkcdEmbed(SlashCommandInteractionEvent event, String title,
      String desc, String imgUrl, String footerText) {
    return EmbedBuilder()
      ..title = title
      ..description = desc
      ..color = DiscordColor.sapGreen
      ..imageUrl = imgUrl
      ..addFooter((footer) {
        footer.text = footerText;
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });
  }

  Future<dynamic> xkcdLatestComicInfo() async {
    late Response response;
    try {
      response = await dio.get('$BASE_URL/info.0.json');
    } on DioError catch (err) {
      print(err);
    }
    return response.data;
  }

  Future<void> xkcdLatestSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final latestComicInfo = await xkcdLatestComicInfo();

    Timer.periodic(
        const Duration(minutes: 30), (timer) => xkcdLatestComicInfo());

    final publishedOn = DateTime(int.parse(latestComicInfo['year']),
        int.parse(latestComicInfo['month']), int.parse(latestComicInfo['day']));

    final embed = xkcdEmbed(
        event,
        "${latestComicInfo['safe_title']}",
        latestComicInfo['alt'],
        latestComicInfo['img'],
        "#${latestComicInfo['num']} • ${latestComicInfo['safe_title']}")
      ..timestamp = publishedOn;
    await event.respond(MessageBuilder.embed(embed));
  }

  Future<void> xkcdComicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final comic = event.getArg('comic').value;

    late Response response;
    try {
      response = await dio.get('$BASE_URL/$comic/info.0.json');
    } on DioError catch (err) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          '${err.response?.statusCode}: Could not retrieve xkcd comic #$comic',
          event.interaction.userAuthor)));
    }

    final comicInfo = response.data;
    final publishedOn = DateTime(int.parse(comicInfo['year']),
        int.parse(comicInfo['month']), int.parse(comicInfo['day']));

    final embed = xkcdEmbed(
        event,
        "${comicInfo['safe_title']}",
        comicInfo['alt'],
        comicInfo['img'],
        "#${comicInfo['num']} • ${comicInfo['safe_title']}")
      ..timestamp = publishedOn;
    await event.respond(MessageBuilder.embed(embed));
  }
}
