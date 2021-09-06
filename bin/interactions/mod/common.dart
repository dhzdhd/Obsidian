import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../utils/database.dart';
import '../../obsidian_dart.dart' show botInteractions;

class ModCommonInteractions {
  ModCommonInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'warn',
        'Warns user with reason.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member.',
              required: true),
          CommandOptionBuilder(
              CommandOptionType.string, 'reason', 'Reason for warn.')
        ],
      )..registerHandler(warnSlashCommand))
      ..registerSlashCommand(
          SlashCommandBuilder('mute', 'Mutes user for a certain time period.', [
        CommandOptionBuilder(CommandOptionType.user, 'user', 'A server member',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.integer, 'time', 'Time period of mute.',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'reason', 'Reason for mute.')
      ], permissions: [
        ICommandPermissionBuilder.role(
            PermissionsConstants.administrator.toSnowflake())
      ]))
      ..registerSlashCommand(
          SlashCommandBuilder('unmute', 'Unmutes muted user.', [
        CommandOptionBuilder(CommandOptionType.user, 'user', 'A server member',
            required: true)
      ]))
      ..registerSlashCommand(
          SlashCommandBuilder('ban', 'Bans user with optional reason.', [
        CommandOptionBuilder(CommandOptionType.user, 'user', 'A server member',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'reason', 'Reason for ban.')
      ]));
  }

  Future<void> warnSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    await Database.add(670237058052390933, 771778089779855391, 'warns', 1);
  }
}
