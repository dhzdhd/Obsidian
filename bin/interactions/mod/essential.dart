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
        'purge',
        'Delete a set number of messages.',
        [
          CommandOptionBuilder(CommandOptionType.integer, 'amount',
              'The number of messages to be deleted.')
        ],
      )..registerHandler(purgeSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder(
        'censor',
        'Delete certain amount of messages based on a keyword.',
        [
          CommandOptionBuilder(CommandOptionType.string, 'keyword',
              'The keyword based on which messages are deleted.'),
          CommandOptionBuilder(CommandOptionType.integer, 'amount',
              'Amount of messages to be deleted.')
        ],
      ));
  }

  Future<void> purgeSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final amount = event.getArg('anount').value;

    final channel = event.interaction.channel.getFromCache();
    final toDelete = await channel?.downloadMessages(limit: amount).toList()
        as Iterable<Message>;
    await channel?.bulkRemoveMessages(toDelete);
  }
}
