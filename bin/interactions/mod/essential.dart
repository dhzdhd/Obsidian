import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import '../../obsidian_dart.dart' show botInteractions;

class ModEssentialInteractions {
  ModEssentialInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'purge',
        'Delete a set number of messages.',
        [
          CommandOptionBuilder(CommandOptionType.integer, 'amount',
              'The number of messages to be deleted.',
              required: true)
        ],
      )..registerHandler(purgeSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder(
        'censor',
        'Delete certain amount of messages based on a keyword.',
        [
          CommandOptionBuilder(CommandOptionType.string, 'keyword',
              'The keyword based on which messages are deleted.',
              required: true),
          CommandOptionBuilder(CommandOptionType.integer, 'amount',
              'Index from latest message of messages to be deleted.',
              required: true)
        ],
      )..registerHandler(censorSlashCommand));
  }

  Future<void> purgeSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final amount = event.getArg('amount').value;

    final channel = event.interaction.channel.getFromCache();
    final toDelete = await channel?.downloadMessages(limit: amount).toList()
        as Iterable<Message>;
    await channel?.bulkRemoveMessages(toDelete);
  }

  Future<void> censorSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final amount = event.getArg('amount').value;
    final keyword = event.getArg('keyword').value;

    var toDelete = [];
    final channel = event.interaction.channel.getFromCache();
    final messageList = await channel?.downloadMessages(limit: amount).toList()
        as Iterable<Message>;
    messageList.forEach((element) {
      if (element.content.contains(keyword)) {
        toDelete.add(element);
      }
    });

    await channel?.bulkRemoveMessages(toDelete as Iterable<Message>);
  }
}
