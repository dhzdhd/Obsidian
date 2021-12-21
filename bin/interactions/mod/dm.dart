import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import '../../obsidian_dart.dart' show botInteractions;
import '../../utils/constraints.dart';
import '../../utils/embed.dart';

class ModDmInteractions {
  ModDmInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'dm',
      '<OWNER ONLY> DM a given user.',
      [
        CommandOptionBuilder(
          CommandOptionType.user,
          'user',
          "The user to be DM'ed.",
          required: true,
        ),
        CommandOptionBuilder(
          CommandOptionType.string,
          'message',
          "The message to be DM'ed to the user.",
          required: true,
        )
      ],
    )..registerHandler(dmSlashCommand));
  }

  Future<void> dmSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge(hidden: true);
    final user = event.interaction.resolved?.users.first;
    final message = event.getArg('message').value;

    if (!(await checkForOwner(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
      return;
    }

    await user?.sendMessage(MessageBuilder.content(message));

    await event.respond(MessageBuilder.content('Successfully sent message!'),
        hidden: true);
  }
}
