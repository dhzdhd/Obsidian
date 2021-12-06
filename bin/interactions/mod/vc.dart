import '../../obsidian_dart.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:nyxx/nyxx.dart';

import '../../utils/constraints.dart';
import '../../utils/embed.dart';

class ModVcInteractions {
  ModVcInteractions() {
    botInteractions
      ..registerSlashCommand(
        SlashCommandBuilder(
          'vc',
          'Voice channel group of commands.',
          [
            CommandOptionBuilder(
              CommandOptionType.subCommand,
              'mute',
              '<MOD ONLY> Mute VC members.',
              options: [
                CommandOptionBuilder(
                    CommandOptionType.user, 'user', 'User to mute in VC')
              ],
            ),
            CommandOptionBuilder(
              CommandOptionType.subCommand,
              'unmute',
              '<MOD ONLY> Unmute VC members.',
              options: [
                CommandOptionBuilder(
                    CommandOptionType.user, 'user', 'User to unmute in VC')
              ],
            ),
          ],
        ),
      )
      ..registerButtonHandler('vc-mute-all', vcMuteButtonHandler);
  }

  Future<void> vcMuteSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }
  }

  Future<void> vcMuteButtonHandler(ButtonInteractionEvent event) async {
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

  Future<void> vcUnmuteSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }
  }
}
