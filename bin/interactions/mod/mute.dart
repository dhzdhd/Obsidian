import 'package:nyxx/nyxx.dart';

import '../../obsidian_dart.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../utils/constants.dart';

class ModMuteInteractions {
  ModMuteInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'mute',
        '<MOD ONLY> Mutes user for a certain time period.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member',
              required: true),
          CommandOptionBuilder(CommandOptionType.integer, 'time',
              'Time period of mute in minutes.',
              required: true),
          CommandOptionBuilder(
              CommandOptionType.string, 'reason', 'Reason for mute.')
        ],
      ))
      ..registerSlashCommand(SlashCommandBuilder(
        'unmute',
        '<MOD ONLY> Unmutes muted user.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member',
              required: true)
        ],
      ));
  }

  Future<void> muteSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final user = event.interaction.resolved?.users.first;
    final time = event.getArg('time').value;
    final reason = event.getArg('reason').value ?? 'No reason provided';

    var a = event.interaction.guild?.getFromCache()?.fetchRoles();
    print(a);

    final muteEmbed = EmbedBuilder()
      ..title =
          ':mute: Muted user: ${user?.username} for time: **$time** minutes.'
      ..description = '**$reason**'
      ..color = Colors.AUDIT_COLORS['mod']
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });
  }
}
