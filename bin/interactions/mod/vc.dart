import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';

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
              'Mute VC members.',
              options: [
                CommandOptionBuilder(
                    CommandOptionType.user, 'user', 'User to mute in VC')
              ],
            )..registerHandler(vcMuteSlashCommand),
            CommandOptionBuilder(
              CommandOptionType.subCommand,
              'unmute',
              'Unmute VC members.',
              options: [
                CommandOptionBuilder(
                    CommandOptionType.user, 'user', 'User to unmute in VC')
              ],
            )..registerHandler(vcUnmuteSlashCommand),
          ],
        ),
      )
      ..registerButtonHandler('vc-mute-all', vcMuteButtonHandler);
  }

  Future<void> vcMuteSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
  }

  Future<void> vcMuteButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();
  }

  Future<void> vcUnmuteSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
  }
}
