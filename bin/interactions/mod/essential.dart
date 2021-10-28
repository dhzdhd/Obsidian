import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import '../../obsidian_dart.dart' show botInteractions;
import '../../utils/constraints.dart';
import '../../utils/embed.dart';

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
    await event.acknowledge(hidden: true);
    final amount = event.getArg('amount').value;
    final channel = event.interaction.channel.getFromCache();

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('You do not have the permissions to use this command!',
            event.interaction.userAuthor),
      ));
      return;
    }

    if (amount < 2 || amount > 100) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Amount must be at least 2 and at most 100.',
          event.interaction.userAuthor)));
      return;
    }

    final toDelete =
        await channel?.downloadMessages(limit: amount).toList() ?? [];

    try {
      await channel?.bulkRemoveMessages(toDelete);
    } catch (err) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'You can only bulk delete messages that are under 14 days old.',
          event.interaction.userAuthor)));
      return;
    }

    await event.respond(MessageBuilder.embed(
      successEmbed(
          'Deleted **$amount** messages', event.interaction.userAuthor),
    ));
  }

  Future<void> censorSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge(hidden: true);
    final amount = event.getArg('amount').value;
    final keyword = event.getArg('keyword').value;
    final channel = event.interaction.channel.getFromCache();

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('You do not have the permissions to use this command!',
            event.interaction.userAuthor),
      ));
      return;
    }

    if (amount < 2 || amount > 100) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Amount must be at least 2 and at most 100.',
          event.interaction.userAuthor)));
      return;
    }

    List<Message> toDelete = [];
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
      await event.respond(MessageBuilder.embed(errorEmbed(
          'You can only bulk delete messages that are under 14 days old.',
          event.interaction.userAuthor)));
      return;
    }

    await event.respond(MessageBuilder.embed(
      successEmbed('Deleted **${toDelete.length}** messages',
          event.interaction.userAuthor),
    ));
  }
}
