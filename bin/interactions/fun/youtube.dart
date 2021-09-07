import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:dio/dio.dart';

import '../../utils/constants.dart';
import '../../obsidian_dart.dart' show botInteractions;
import '../../utils/embed.dart';

class FunYoutubeInteractions {
  FunYoutubeInteractions() {
    botInteractions
      ..registerSlashCommand(
          SlashCommandBuilder('youtube', 'Search for a youtube video.', [
        CommandOptionBuilder(
            CommandOptionType.string, 'query', 'The video name.',
            required: true)
      ])
            ..registerHandler(ytSlashCommand))
      ..registerMultiselectHandler('youtube', ytOptionHandler);
  }

  static const LOCATION = '(37.0902,95.7129)';
  static const YT_URL = 'https://www.googleapis.com/youtube/v3/search/';
  late Message message;
  var dio = Dio();
  var params = {
    'key': Tokens.YT_KEY,
    'part': 'snippet',
    'maxResults': 5,
    'videoEmbeddable': 'true',
    'type': 'video',
  };

  Future<void> ytOptionHandler(MultiselectInteractionEvent event) async {
    await event.acknowledge();

    await event.sendFollowup(MessageBuilder.content(
      'https://www.youtube.com/watch?v=${event.interaction.values.first}',
    ));

    await message.delete();
  }

  Future<void> ytSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    var vidIdList = [];
    final query = await event.interaction.options.first.value;
    params['q'] = query;

    late final videoList;
    late final errEmbed;

    try {
      var response = await dio.get(YT_URL, queryParameters: params);
      videoList = response.data['items'];
      var _ = videoList[0];
    } on DioError catch (err) {
      var code = err.response?.statusCode;
      if (code == 403) {
        errEmbed = errorEmbed(
            'YT API Quota finished. Sorry for the inconvenience.',
            event.interaction.userAuthor);

        await event.respond(MessageBuilder.embed(errEmbed));
        return;
      }
    } on RangeError catch (_) {
      errEmbed = errorEmbed(
          'The requested video was not found. Try with a different query.',
          event.interaction.userAuthor);

      await event.respond(MessageBuilder.embed(errEmbed));
      return;
    }

    var ytEmbed = EmbedBuilder()
      ..title = 'Youtube search : $query'
      ..color = DiscordColor.rose
      ..timestamp = DateTime.now()
      ..thumbnailUrl =
          'https://assets.stickpng.com/thumbs/580b57fcd9996e24bc43c545.png'
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    for (var _ = 0; _ < 5; _++) {
      ytEmbed.addField(
          name: '${_ + 1}) ${videoList[_]['snippet']['title']}',
          content: videoList[_]['snippet']['thumbnails']['high']['url'],
          inline: false);
      vidIdList.add(videoList[_]['id']['videoId']);
    }

    message = await event.sendFollowup(MessageBuilder.embed(ytEmbed));

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(MultiselectBuilder(
        'youtube',
        [
          for (var _ = 0; _ < 5; _++)
            MultiselectOptionBuilder('Option ${_ + 1}', vidIdList[_])
        ],
      ));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
  }
}
