import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

Future<void> inviteBotSlashCommand(InteractionEvent event) async {
  await event.acknowledge();

  final inviteURL = await event.interactions.client.inviteLink;
  await event.respond(
      MessageBuilder.content('**Invite link: $inviteURL (No permissions!!)**'));
}

Future<void> latencySlashCommand(SlashCommandInteractionEvent event) async {
  await event.acknowledge();

  final _gatewayLatency = event.interactions.client.shardManager.shards.first
      .gatewayLatency.inMilliseconds;

  final _apiStopwatch = Stopwatch()..start();
  await http.head(
      Uri(scheme: 'https', host: Constants.host, path: Constants.baseUri));
  final _apiLatency = _apiStopwatch.elapsedMilliseconds;
  _apiStopwatch.stop();

  final _latencyEmbed = EmbedBuilder()
    ..color = DiscordColor.purple
    ..title = 'Latency'
    ..timestamp = DateTime.utc(2021)
    ..addField(
        name: 'Gateway latency', content: '$_gatewayLatency ms', inline: false)
    ..addField(name: 'REST latency', content: '$_apiLatency ms', inline: false)
    ..addField(name: 'Message latency', content: 'Pending ...', inline: false)
    ..addFooter((footer) {
      footer.text = 'Requested by: ${event.interaction.userAuthor?.username}';
      footer.iconUrl = event.interaction.userAuthor?.avatarURL();
    });

  final _messageStopwatch = Stopwatch()..start();
  final _message =
      await event.sendFollowup(MessageBuilder.embed(_latencyEmbed));

  _latencyEmbed.replaceField(
    name: 'Message latency',
    content: '${_messageStopwatch.elapsedMilliseconds} ms',
    inline: false,
  );

  // await _message.edit(embed: _latencyEmbed);
  _messageStopwatch.stop();
}
