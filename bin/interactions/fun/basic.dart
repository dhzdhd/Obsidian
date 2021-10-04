import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import '../../obsidian_dart.dart' show botInteractions;
import '../../utils/constants.dart';

final _random = Random();

class FunBasicInteractions {
  FunBasicInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'avatar',
        'Shows the user profile picture/gif.',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member.')
        ],
      )..registerHandler(avatarSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder('roll', 'Roll a die.', [])
        ..registerHandler(rollSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder('flip', 'Flip a coin.', [])
        ..registerHandler(flipSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder(
        'rip',
        'Create a rip user message',
        [
          CommandOptionBuilder(
              CommandOptionType.user, 'user', 'A server member.',
              required: true)
        ],
      )..registerHandler(ripUserSlashCommand));
  }

  Future<void> avatarSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final avatar = event.interaction.resolved?.users.first
            .avatarURL(format: 'png', size: 256) ??
        event.interaction.userAuthor?.avatarURL(format: 'png', size: 256);

    await event.respond(MessageBuilder.content(avatar.toString()));
  }

  Future<void> rollSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    await event.respond(
        MessageBuilder.content(':game_die: ${_random.nextInt(7) - 1}'));
  }

  Future<void> flipSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    await event.respond(MessageBuilder.content(
        ':coin: ${['Heads', 'Tails'][_random.nextInt(2)]}'));
  }

  Future<void> ripUserSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final user = event.interaction.resolved?.users.first;
    final year = DateTime.now().year;
    final channel = event.interaction.channel.getFromCache();

    final firstMessage = '''
He won't be missed
Gone and forgotten
${user?.avatarURL(format: 'png', size: 128)}
    ''';
    final secondMessage = '''
:bird: $year-$year :bird:
1 like :heart: = 1 prayer :pray:
    ''';

    await event.respond(MessageBuilder.content(Emojis.RIP));
    await channel?.sendMessage(MessageBuilder.content(firstMessage));
    await channel?.sendMessage(MessageBuilder.content(secondMessage));
  }
}
