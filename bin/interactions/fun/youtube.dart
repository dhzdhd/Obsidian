import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:dio/dio.dart';

import '../../utils/constants.dart';

const LOCATION = '(37.0902,95.7129)';
const YT_URL = 'https://www.googleapis.com/youtube/v3/search/';
var params = {
  'key': Tokens.YT_KEY,
  'part': 'snippet',
  'maxResults': 10,
  'videoEmbeddable': 'true',
  'type': 'video',
};
var dio = Dio();

Future<void> ytOptionHandler(MultiselectInteractionEvent event) async {
  await event.acknowledge();

  event.interaction.values.first;
}

Future<void> ytSlashCommand(SlashCommandInteractionEvent event) async {
  await event.acknowledge();

  params['q'] = await event.interaction.options.first.value;
  print(params['q']);

  var response = await dio.get(YT_URL, queryParameters: params);
  print(response.data.toString());

  await event.sendFollowup(MessageBuilder.content('sussy amogus sus sus'));

  final componentMessageBuilder = ComponentMessageBuilder();
  final componentRow = ComponentRowBuilder()
    ..addComponent(MultiselectBuilder('youtube', [
      MultiselectOptionBuilder('1', 'ooga booga', true),
      MultiselectOptionBuilder('2', 'booga ooga'),
      MultiselectOptionBuilder('3', 'booga ooga'),
      MultiselectOptionBuilder('4', 'booga ooga'),
      MultiselectOptionBuilder('5', 'booga ooga')
    ]));
  componentMessageBuilder.addComponentRow(componentRow);

  await event.respond(componentMessageBuilder);
}
