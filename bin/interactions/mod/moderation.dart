import 'package:nyxx_interactions/interactions.dart';

Future<void> warnSlashCommand(SlashCommandInteractionEvent event) async {
  await event.acknowledge();
}
