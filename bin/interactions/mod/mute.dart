import 'package:nyxx/nyxx.dart';

import '../../obsidian_dart.dart';
import 'package:nyxx_interactions/interactions.dart';

class ModMuteInteractions {
  ModMuteInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'mute',
        'Mutes user for a certain time period.',
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
        permissions: [
          ICommandPermissionBuilder.role(
              PermissionsConstants.manageGuild.toSnowflake())
        ],
      ))
      ..registerSlashCommand(SlashCommandBuilder(
        'unmute',
        'Unmutes muted user.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member',
              required: true)
        ],
        permissions: [
          ICommandPermissionBuilder.role(
              PermissionsConstants.manageGuild.toSnowflake())
        ],
      ));
  }

  Future<void> muteSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final user = event.interaction.resolved?.users.first;
    final time = event.interaction.options.elementAt(1);
    final reason = event.interaction.options.elementAt(2).value;

    final muteEmbed = EmbedBuilder()
      ..title =
          ':mute: Muted user: ${user?.username} for time: **$time** minutes.'
      ..description = "**${reason == null ? 'No reason given' : reason}**";
  }
}
