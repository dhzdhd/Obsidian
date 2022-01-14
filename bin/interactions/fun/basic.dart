import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import '../../obsidian_dart.dart' show botInteractions;
import '../../utils/constants.dart';

class FunBasicInteractions {
  final _random = Random();

  FunBasicInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'avatar',
        'Shows the user profile picture/gif.',
        [
          CommandOptionBuilder(
            CommandOptionType.user,
            'user',
            'A server member.',
          ),
        ],
      )..registerHandler(avatarSlashCommand))
      // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      ..registerSlashCommand(SlashCommandBuilder(
        'avatar',
        null,
        [],
        type: SlashCommandType.user,
      )..registerHandler(avatarSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder('roll', 'Roll a die.', [])
        ..registerHandler(rollSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder('flip', 'Flip a coin.', [])
        ..registerHandler(flipSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder(
        'rip',
        'Create a rip user message.',
        [
          CommandOptionBuilder(
            CommandOptionType.user,
            'user',
            'A server member.',
            required: true,
          )
        ],
      )..registerHandler(ripUserSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder(
        'google',
        'Get a google search link for the given query.',
        [
          CommandOptionBuilder(
            CommandOptionType.string,
            'query',
            'The query to be googled.',
            required: true,
          )
        ],
      )..registerHandler(googleSlashCommand));
  }

  Future<void> avatarSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final avatar = event.interaction.resolved?.users.first
            .avatarURL(format: 'png', size: 256) ??
        event.interaction.userAuthor?.avatarURL(format: 'png', size: 256);

    await event.respond(MessageBuilder.content(avatar!));
  }

  Future<void> rollSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();
    await event.respond(
        MessageBuilder.content(':game_die: ${_random.nextInt(6) + 1}'));
  }

  Future<void> flipSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();
    await event.respond(MessageBuilder.content(
        ':coin: ${['Heads', 'Tails'][_random.nextInt(2)]}'));
  }

  Future<void> ripUserSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final user = event.interaction.resolved?.users.first;
    final channel = event.interaction.channel.getFromCache();
    final year = DateTime.now().year;

    final firstMessage = '''
They won't be missed
Gone and forgotten
${user?.avatarURL(format: 'png', size: 128)}
    ''';
    final secondMessage = '''
:bird: $year-$year :bird:
1 like :heart: = 1 prayer :pray:
    ''';

    await event.respond(MessageBuilder.content(Emojis.rip));
    await channel?.sendMessage(MessageBuilder.content(firstMessage));
    await channel?.sendMessage(MessageBuilder.content(secondMessage));
  }

  Future<void> googleSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final query = event.getArg('query').value.toString();
    final author = event.interaction.userAuthor!;

    await event.respond(MessageBuilder.embed(
      EmbedBuilder()
        ..title = 'Google search: $query'
        ..description =
            'https://www.google.com/search?q=${query.trim().replaceAll(' ', '+')}'
        ..thumbnailUrl =
            'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-vector-graphic-pixabay-15.png'
        ..color = DiscordColor.flutterBlue
        ..timestamp = DateTime.now()
        ..addFooter((footer) {
          footer.text = 'Requested by ${author.username}';
          footer.iconUrl = author.avatarURL();
        }),
    ));
  }
}
