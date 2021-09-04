import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:dio/dio.dart';

import '../../utils/constants.dart';

const LOCATION = '(37.0902,95.7129)';
const YT_URL = 'https://www.googleapis.com/youtube/v3/search/';
var params = {
  'key': Tokens.YT_KEY,
  'part': 'snippet',
  'maxResults': 5,
  'videoEmbeddable': 'true',
  'type': 'video',
};
var dio = Dio();

Future<void> ytOptionHandler(MultiselectInteractionEvent event) async {
  await event.acknowledge();

  await event.sendFollowup(MessageBuilder.content(
    'https://www.youtube.com/watch?v=${event.interaction.values.first}',
  ));
}

Future<void> ytSlashCommand(SlashCommandInteractionEvent event) async {
  await event.acknowledge();

  var vidIdList = [];
  final query = await event.interaction.options.first.value;
  params['q'] = query;

  var response = await dio.get(YT_URL, queryParameters: params);
  print(response.data['items'].toString());
  final videoList = response.data['items'];

  var ytEmbed = EmbedBuilder()..title = 'Youtube search : $query';
  for (var _ = 0; _ < 5; _++) {
    ytEmbed.addField(
        name: '${_ + 1}) ${videoList[_]['snippet']['title']}',
        content: videoList[_]['snippet']['thumbnails']['high']['url'],
        inline: false);
    vidIdList.add(videoList[_]['id']['videoId']);
  }

  await event.sendFollowup(MessageBuilder.embed(ytEmbed));

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
