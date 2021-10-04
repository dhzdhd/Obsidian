import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import '../../obsidian_dart.dart' show botInteractions;
import '../../utils/constraints.dart';

class ModEssentialInteractions {
  ModEssentialInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'purge',
        '<MOD ONLY> Delete a set number of messages.',
        [
          CommandOptionBuilder(CommandOptionType.integer, 'amount',
              'The number of messages to be deleted.',
              required: true)
        ],
      )..registerHandler(purgeSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder(
        'censor',
        '<MOD ONLY> Delete certain amount of messages based on a keyword.',
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

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.content(
          'You do not have the permissions to use this command!'));
      return;
    }

    final channel = event.interaction.channel.getFromCache();
    final toDelete =
        await channel?.downloadMessages(limit: amount).toList() ?? [];

    try {
      await channel?.bulkRemoveMessages(toDelete);
    } catch (err) {
      await event.respond(
          MessageBuilder.content('Amount must be at least 2 and at most 100'),
          hidden: true);
    }
  }

  Future<void> censorSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final amount = event.getArg('amount').value;
    final keyword = event.getArg('keyword').value;

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.content(
          'You do not have the permissions to use this command!'));
      return;
    }

    List<Message> toDelete = [];
    final channel = event.interaction.channel.getFromCache();
    final messageList = await channel?.downloadMessages(limit: amount).toList()
        as Iterable<Message>;
    messageList.forEach((element) {
      if (element.content.contains(keyword)) {
        toDelete.add(element);
      }
    });

    try {
      await channel?.bulkRemoveMessages(toDelete);
    } catch (err) {
      await event.respond(
        MessageBuilder.content('Amount must be at least 2 and at most 100'),
        hidden: true,
      );
    }
  }
}
