import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart' show botInteractions;
import '../../utils/constraints.dart';
import '../../utils/embed.dart';

class UtilsCommonInteractions {
  UtilsCommonInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'invite',
        '<MOD ONLY> Send bot invite link.',
        [],
      )..registerHandler(inviteBotSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder(
        'ping',
        'Get latency of bot',
        [],
      )..registerHandler(latencySlashCommand));
  }
}

Future<void> inviteBotSlashCommand(SlashCommandInteractionEvent event) async {
  await event.acknowledge();
  final guild = event.interaction.guild?.getFromCache();
  final channel = event.interaction.guild
      ?.getFromCache()
      ?.channels
      .firstWhere((element) => element.channelType == ChannelType.text);

  if (!(await checkForMod(event))) {
    await event.respond(MessageBuilder.embed(
      errorEmbed('Permission Denied!', event.interaction.userAuthor),
    ));
    return;
  }

  late Invite? invite;
  try {
    invite = await guild?.fetchGuildInvites().first;
  } catch (err) {
    invite = await channel?.createInvite(temporary: false, unique: false);
  }

  final inviteUrl = invite?.url;
  await event
      .respond(MessageBuilder.content('Server invite URL: **$inviteUrl**'));
}

Future<void> latencySlashCommand(SlashCommandInteractionEvent event) async {
  await event.acknowledge();

  final gatewayLatency = event.client.shardManager.gatewayLatency.inSeconds;

  final apiStopwatch = Stopwatch()..start();
  await http.head(
      Uri(scheme: 'https', host: Constants.host, path: Constants.baseUri));
  final apiLatency = apiStopwatch.elapsedMilliseconds;
  apiStopwatch.stop();

  final latencyEmbed = EmbedBuilder()
    ..color = DiscordColor.purple
    ..title = 'Latency'
    ..timestamp = DateTime.now()
    ..addField(
        name: 'Gateway latency', content: '$gatewayLatency ms', inline: false)
    ..addField(name: 'REST latency', content: '$apiLatency ms', inline: false)
    ..addField(name: 'Message latency', content: 'Pending ...', inline: false)
    ..addFooter((footer) {
      footer.text = 'Requested by: ${event.interaction.userAuthor?.username}';
      footer.iconUrl = event.interaction.userAuthor?.avatarURL();
    });

  final messageStopwatch = Stopwatch()..start();
  final message = await event.sendFollowup(MessageBuilder.embed(latencyEmbed));

  latencyEmbed.replaceField(
    name: 'Message latency',
    content: '${messageStopwatch.elapsedMilliseconds} ms',
    inline: false,
  );

  await message.edit(MessageBuilder.embed(latencyEmbed));
  messageStopwatch.stop();
}
