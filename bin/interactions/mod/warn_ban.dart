import '../../obsidian_dart.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx/nyxx.dart';

import '../../utils/constants.dart';
import '../../utils/constraints.dart';
import '../../utils/database.dart';
import '../../utils/embed.dart';

class ModWarnBanInteractions {
  ModWarnBanInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'warn',
        '<MOD ONLY> Warns user with reason.',
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
        'ban',
        '<MOD ONLY> Bans user with optional reason.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member',
              required: true),
          CommandOptionBuilder(
              CommandOptionType.string, 'reason', 'Reason for ban.')
        ],
      )..registerHandler(banSlashCommand))
      ..registerButtonHandler('ban', banButtonHandler);
  }

  Future<void> warnSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final user = event.interaction.resolved?.users.first;
    final reason = event.getArg('reason').value;

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
          errorEmbed('Permission Denied!', event.interaction.userAuthor)));
      return;
    }

    final warnEmbed = EmbedBuilder()
      ..title = ':warning: Warned user: ${user?.username}'
      ..description = '**$reason**'
      ..color = Colors.AUDIT_COLORS['mod']
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    var response = await UserDatabase.add(
        user?.id.id as int, event.interaction.guild?.id.id as int, 'warns', 1);

    if (response) {
      await event.respond(MessageBuilder.embed(warnEmbed));
    } else {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Error in warning the user!', event.interaction.userAuthor)));
    }
  }

  // TODO: Implement deleteMessageDays in ban()
  Future<void> banSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final user = event.interaction.resolved?.users.first;
    final member = event.interaction.resolved?.members.first;
    final reason = event.getArg('reason').value;

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
          errorEmbed('Permission Denied!', event.interaction.userAuthor)));
      return;
    }

    try {
      await member?.ban(auditReason: reason);
    } catch (err) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Error in banning the user!', event.interaction.userAuthor)));
      return;
    }

    final banEmbed = EmbedBuilder()
      ..title = ':warning: Banned user: ${user?.username}'
      ..description = '**$reason**'
      ..color = Colors.AUDIT_COLORS['mod']
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    var response = await UserDatabase.add(
        user?.id.id as int, event.interaction.guild?.id.id as int, 'bans', 1);

    if (response) {
      await event.respond(MessageBuilder.embed(banEmbed));
    } else {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Error in adding ban data to the database!',
          event.interaction.userAuthor)));
    }
  }

  Future<void> banButtonHandler(IButtonInteractionEvent event) async {
    await event.acknowledge();

    if (!(await checkForMod(event))) {
      await event.interaction.userAuthor
          ?.sendMessage(MessageBuilder.embed(errorEmbed(
        'You do not have the permissions to use this button!',
        event.interaction.userAuthor,
      )));
      return;
    }
  }
}
