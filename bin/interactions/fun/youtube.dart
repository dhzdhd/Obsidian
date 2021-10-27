import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:dio/dio.dart';

import '../../utils/constants.dart';
import '../../obsidian_dart.dart' show botInteractions, dio;
import '../../utils/embed.dart';

class FunYoutubeInteractions {
  static const YT_URL = 'https://www.googleapis.com/youtube/v3/search/';
  Map<int, Message> messageMap = {};
  var params = {
    'key': Tokens.YT_KEY,
    'part': 'snippet',
    'maxResults': 5,
    'videoEmbeddable': 'true',
    'type': 'video',
  };

  FunYoutubeInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'youtube',
        'Search for a youtube video.',
        [
          CommandOptionBuilder(
              CommandOptionType.string, 'query', 'The video name.',
              required: true)
        ],
      )..registerHandler(ytSlashCommand))
      ..registerMultiselectHandler('youtube', ytOptionHandler);
  }

  Future<void> ytSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    var vidIdList = [];
    late final List videoList;
    late final EmbedBuilder errEmbed;

    final query = await event.getArg('query').value;
    params['q'] = query;

    try {
      final response = await dio.get(YT_URL, queryParameters: params);
      videoList = response.data['items'];
      var _ = videoList[0];
    } on DioError catch (err) {
      final code = err.response?.statusCode;
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

    for (var _ = 0; _ < videoList.length; _++) {
      ytEmbed.addField(
          name: '${_ + 1}) ${videoList[_]['snippet']['title']}',
          content:
              '[Thumbnail](${videoList[_]['snippet']['thumbnails']['high']['url']})',
          inline: false);
      vidIdList.add(videoList[_]['id']['videoId']);
    }

    final message = await event.sendFollowup(MessageBuilder.embed(ytEmbed));
    messageMap[message.id.id] = message;

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(MultiselectBuilder(
        'youtube',
        [
          for (var _ = 0; _ < vidIdList.length; _++)
            MultiselectOptionBuilder('Option ${_ + 1}', vidIdList[_])
        ],
      ));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
  }

  Future<void> ytOptionHandler(MultiselectInteractionEvent event) async {
    await event.acknowledge();

    await event.sendFollowup(MessageBuilder.content(
      'https://www.youtube.com/watch?v=${event.interaction.values.first}',
    ));

    await messageMap[event.interaction.message!.id.id]!.delete();
  }
}
