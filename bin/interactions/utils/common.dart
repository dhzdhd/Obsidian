import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart' show botInteractions;

class UtilsCommonInteractions {
  UtilsCommonInteractions() {
    botInteractions.registerSlashCommand(
        SlashCommandBuilder('invite', 'Send bot invite link.', [])
          ..registerHandler(inviteBotSlashCommand));
  }
}

Future<void> inviteBotSlashCommand(InteractionEvent event) async {
  await event.acknowledge();

  final inviteURL = await event.interaction.guild
      ?.getFromCache()
      ?.channels
      .first
      .createInvite(temporary: false);
  await event.respond(
      MessageBuilder.content('**Invite link: $inviteURL (No permissions!!)**'));
}

/// FIXME:
Future<void> latencySlashCommand(SlashCommandInteractionEvent event) async {
  await event.acknowledge();

  final _gatewayLatency = event.interaction;

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

  // await _message.edit(MessageBuilder.embed(_latencyEmbed));
  _messageStopwatch.stop();
}
