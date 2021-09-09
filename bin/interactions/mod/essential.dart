import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:postgres/postgres.dart';

import '../../utils/constants.dart';
import '../../utils/database.dart';
import '../../obsidian_dart.dart' show botInteractions;

class ModEssentialInteractions {
  ModEssentialInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'warn',
        'Warns user with reason.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member.',
              required: true),
          CommandOptionBuilder(
              CommandOptionType.string, 'reason', 'Reason for warn.',
              required: true)
        ],
      )..registerHandler(warnSlashCommand))
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
      ))
      ..registerSlashCommand(SlashCommandBuilder(
        'ban',
        'Bans user with optional reason.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member',
              required: true),
          CommandOptionBuilder(
              CommandOptionType.string, 'reason', 'Reason for ban.')
        ],
        permissions: [
          ICommandPermissionBuilder.role(
              PermissionsConstants.banMembers.toSnowflake())
        ],
      ));
  }

  Future<void> warnSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final user = event.interaction.resolved?.users.first;
    final reason = event.interaction.options.elementAt(1).value;

    final warnEmbed = EmbedBuilder()
      ..title = ':warning: Warned user: ${user?.username}'
      ..description = '**$reason**'
      ..color = Colors.AUDIT_COLORS['mod']
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    try {
      await Database.add(user?.id.id as int,
          event.interaction.guild?.id.id as int, 'warns', 1);
    } on PostgreSQLException catch (err) {
      print(err.toString());
    }

    await event.respond(MessageBuilder.embed(warnEmbed));
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
