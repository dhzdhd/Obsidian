import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

final _random = Random();

Future<void> avatarSlashCommand(SlashCommandInteractionEvent event) async {
  await event.acknowledge();

  final avatar = event.interaction.resolved?.users.first
          .avatarURL(format: 'png', size: 256) ??
      event.interaction.userAuthor?.avatarURL(format: 'png', size: 256);

  await event.respond(MessageBuilder.content(avatar.toString()));
}

Future<void> ripUserSlashCommand(SlashCommandInteractionEvent event) async {}

Future<void> rollSlashCommand(InteractionEvent event) async {
  await event.acknowledge();
  await event
      .respond(MessageBuilder.content(':game_die: ${_random.nextInt(7) - 1}'));
}

Future<void> flipSlashCommand(InteractionEvent event) async {
  await event.acknowledge();
  await event.respond(MessageBuilder.content(
      ':coin: ${['Heads', 'Tails'][_random.nextInt(2)]}'));
}