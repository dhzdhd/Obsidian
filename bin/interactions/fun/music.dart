import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:nyxx_lavalink/lavalink.dart';

import '../../obsidian_dart.dart' show cluster, botInteractions, bot;
import '../../utils/embed.dart';

class FunMusicInteractions {
  FunMusicInteractions() {
    initEvents();
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'music',
        'Music group of commands.',
        [
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'join',
            'Make the bot join a voice channel',
            options: [
              CommandOptionBuilder(CommandOptionType.channel, 'voice-channel',
                  'The voice channel the bot should join.')
            ],
          )..registerHandler(joinMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'play',
            'Play some music.',
            options: [
              CommandOptionBuilder(CommandOptionType.string, 'title',
                  'Title of song to be played.',
                  required: true),
              CommandOptionBuilder(CommandOptionType.channel, 'voice-channel',
                  'The voice channel the music should be played in.')
            ],
          )..registerHandler(playMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'stop',
            'Stop playing music and clear queue.',
          )..registerHandler(stopMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'pause',
            'Pause currently playing music.',
          )..registerHandler(pauseMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'resume',
            'Resume paused music.',
          )..registerHandler(resumeMusicSlashCommand),
        ],
      ))
      ..registerButtonHandler('music', playMusicButtonHandler);
  }

  void initEvents() {
    // bot.onVoiceStateUpdate.listen((event) async {
    //   print(event.raw);
    //   print(event.state.channel);
    // });

    // bot.onVoiceServerUpdate.listen((event) async {
    //   print(event);
    // });
  }

  Future<void> joinMusicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final channel = event.interaction.resolved?.channels.first;
    final c = event.getArg('voice-channel').value;
    print(c);

    late VoiceGuildChannel vc;

    if (channel != null && channel.type == ChannelType.voice) {
      vc = channel as VoiceGuildChannel;
    } else if (channel == null) {
      vc = event.interaction.memberAuthor?.voiceState?.channel?.getFromCache()
          as VoiceGuildChannel;
    } else {
      await event.respond(MessageBuilder.embed(
          errorEmbed('Error', event.interaction.userAuthor)));
      return;
    }

    vc.connect();

    await event.respond(MessageBuilder.embed(
      musicEmbed('Join', 'Joined voice channel: ${event.interaction.channel}',
          event.interaction.userAuthor),
    ));
  }

  // ! Add channel input support
  Future<void> playMusicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    late VoiceGuildChannel vc;
    final guildId = event.interaction.guild!.id;
    var title = event.getArg('title').value.toString();
    // var channel = event.interaction.resolved?.channels.first;

    vc = event.interaction.memberAuthor?.voiceState?.channel?.getFromCache()
        as VoiceGuildChannel;

    final node = cluster.getOrCreatePlayerNode(guildId);
    vc.connect(selfDeafen: true);

    final searchResults = await node.autoSearch(title);
    print(searchResults.tracks[0].info?.title);

    node.play(guildId, searchResults.tracks[0]).queue();

    await event.respond(
      MessageBuilder.embed(musicEmbed(
          'Play', 'Playing song: $title', event.interaction.userAuthor)),
    );
  }

  Future<void> resumeMusicSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node =
        cluster.getOrCreatePlayerNode(event.interaction.guild?.id as Snowflake);
    node.resume(event.interaction.guild?.getFromCache()?.id as Snowflake);

    await event.respond(MessageBuilder.embed(
        musicEmbed('Resume', 'Resumed music.', event.interaction.userAuthor)));
  }

  Future<void> pauseMusicSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node =
        cluster.getOrCreatePlayerNode(event.interaction.guild?.id as Snowflake);
    node.pause(event.interaction.guild?.getFromCache()?.id as Snowflake);

    await event.respond(MessageBuilder.embed(
        musicEmbed('Pause', 'Paused music.', event.interaction.userAuthor)));
  }

  Future<void> stopMusicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node =
        cluster.getOrCreatePlayerNode(event.interaction.guild?.id as Snowflake);
    node.stop(event.interaction.guild?.getFromCache()?.id as Snowflake);

    await event.respond(MessageBuilder.embed(musicEmbed(
        'Stop',
        'Stopped music and removed songs from the queue.',
        event.interaction.userAuthor)));
  }

  Future<void> playMusicButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();
  }
}
