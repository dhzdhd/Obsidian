import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../obsidian_dart.dart';

class UtilsRemindInteraction {
  UtilsRemindInteraction() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'remind',
      'Remind you of an important event.',
      [
        CommandOptionBuilder(
          CommandOptionType.string,
          'event',
          'The event you need to be reminded of.',
          required: true,
        ),
        CommandOptionBuilder(
          CommandOptionType.string,
          'time',
          'The time until which you want to be reminded of the event.',
          required: true,
        ),
      ],
    )..registerHandler(remindSlashCommand));
  }

  DateTime parseTimeString(String rawTime) {
    return DateTime(2020);
  }

  Future<void> remindSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final eventTitle = event.getArg('event');
    final rawTime = event.getArg('time').toString();

    final time = parseTimeString(rawTime);

    final startEmbed = EmbedBuilder()
      ..title = ':white_checkmark: Reminder set | **$eventTitle**'
      ..description = 'Arrives in $time'
      ..color = DiscordColor.hotPink
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    await event.sendFollowup(MessageBuilder.embed(startEmbed));
    Timer(Duration(seconds: 10), () async {
      await event.respond(MessageBuilder.content('done!'));
    });
  }
}
