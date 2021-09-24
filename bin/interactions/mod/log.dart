import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';

class ModLogInteractions {
  ModLogInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'log',
      'Log group of commands.',
      [
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'create',
          'Create a new log channel.',
          options: [
            CommandOptionBuilder(CommandOptionType.channel, 'channel',
                'Channel to assign to logging.')
          ],
        )
      ],
    ));
  }
}
