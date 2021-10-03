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
          '|MOD ONLY| Create a new log channel.',
          options: [
            CommandOptionBuilder(CommandOptionType.channel, 'channel',
                'Channel to assign to logging.',
                required: true)
          ],
        ),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'delete',
          '|MOD ONLY| Delete an existing log channel.',
          options: [
            CommandOptionBuilder(CommandOptionType.channel, 'channel',
                'Logging channel to delete.',
                required: true)
          ],
        )
      ],
    ));
  }
}
