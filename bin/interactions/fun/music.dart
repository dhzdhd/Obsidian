import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:nyxx_lavalink/lavalink.dart';

import '../../obsidian_dart.dart' show cluster, botInteractions, bot;
import '../../utils/constants.dart';
import '../../utils/embed.dart';

class FunMusicInteractions {
  FunMusicInteractions() {
    // initEvents();
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'music',
        'Music group of commands.',
        [
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
            'skip',
            'Skip the currently playing music.',
          )..registerHandler(skipMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'repeat',
            'Repeat the currently playing music.',
          )..registerHandler(repeatMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'resume',
            'Resume paused music.',
          )..registerHandler(resumeMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'pause',
            'Pause currently playing music.',
          )..registerHandler(pauseMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'stop',
            'Stop playing music and clear queue.',
          )..registerHandler(stopMusicSlashCommand),
        ],
      ))
      ..registerMultiselectHandler('music', musicOptionHandler);
  }

  void initEvents() {
    bot.onVoiceStateUpdate.listen((event) async {
      // if (event.state.guild?.getFromCache()?.voiceStates.count == 1) {
      print(event.state.user.getFromCache()!.username);
      // }
    });

    // bot.onVoiceServerUpdate.listen((event) async {
    //   print(event);
    // });
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
    final track = searchResults.tracks[0];
    final trackInfo = track.info;

    node.play(guildId, track).queue();

    await event.sendFollowup(
      MessageBuilder.embed(musicEmbed(
        'Play | ${trackInfo!.title}',
        '''
        Artist: ${trackInfo.author}
        Duration: ${(trackInfo.length / 60000).roundToDouble()} minutes
        URL: ${trackInfo.uri}
        ''',
        event.interaction.userAuthor,
      )..thumbnailUrl =
          'https://img.youtube.com/vi/${trackInfo.identifier}/maxresdefault.jpg'),
    );

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(MultiselectBuilder('music', [
        MultiselectOptionBuilder('Pause', 'pause')
          ..description = 'Pause the current playing track'
          ..emoji = UnicodeEmoji('⏸️'),
        MultiselectOptionBuilder('Resume', 'resume')
          ..description = 'Resume the currently paused track'
          ..emoji = UnicodeEmoji('▶️'),
        MultiselectOptionBuilder('Backward', 'backward')
          ..description = 'Go to the start of the track'
          ..emoji = UnicodeEmoji('⏮️'),
        MultiselectOptionBuilder('Forward', 'forward')
          ..description = 'Go to the next song in the queue'
          ..emoji = UnicodeEmoji('⏩'),
        MultiselectOptionBuilder('Repeat', 'repeat')
          ..description = 'Repeat the given track'
          ..emoji = UnicodeEmoji('🔁'),
        MultiselectOptionBuilder('Stop', 'stop')
          ..description = 'Stop playing tracks and delete the queue'
          ..emoji = UnicodeEmoji('⏹️'),
      ]));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
  }

  Future<void> skipMusicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node =
        cluster.getOrCreatePlayerNode(event.interaction.guild?.id as Snowflake);
    node.skip(event.interaction.guild!.getFromCache()!.id);

    await event.respond(MessageBuilder.embed(
        musicEmbed('Skip', 'Skipped music.', event.interaction.userAuthor)));
  }

  Future<void> repeatMusicSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
    final player = node.createPlayer(event.interaction.guild!.id);

    player.queue.add(player.nowPlaying!);

    await event.respond(MessageBuilder.embed(
        musicEmbed('Resume', 'Resumed music.', event.interaction.userAuthor)));
  }

  Future<void> resumeMusicSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node =
        cluster.getOrCreatePlayerNode(event.interaction.guild?.id as Snowflake);
    node.resume(event.interaction.guild!.getFromCache()!.id);

    await event.respond(MessageBuilder.embed(
        musicEmbed('Resume', 'Resumed music.', event.interaction.userAuthor)));
  }

  Future<void> pauseMusicSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node =
        cluster.getOrCreatePlayerNode(event.interaction.guild?.id as Snowflake);
    node.pause(event.interaction.guild!.getFromCache()!.id);

    await event.respond(MessageBuilder.embed(
        musicEmbed('Pause', 'Paused music.', event.interaction.userAuthor)));
  }

  Future<void> stopMusicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node =
        cluster.getOrCreatePlayerNode(event.interaction.guild?.id as Snowflake);
    node.stop(event.interaction.guild!.getFromCache()!.id);

    await event.respond(MessageBuilder.embed(musicEmbed(
        'Stop',
        'Stopped music and removed songs from the queue.',
        event.interaction.userAuthor)));
  }

  Future<void> musicOptionHandler(MultiselectInteractionEvent event) async {
    await event.acknowledge();
    final value = event.interaction.values.first;
    final guildId = event.interaction.guild!.id;

    final node =
        cluster.getOrCreatePlayerNode(event.interaction.guild?.id as Snowflake);
    final player = node.createPlayer(guildId);

    switch (value) {
      case 'repeat':
        {
          player.queue.add(player.nowPlaying!);
          break;
        }
      case 'backward':
        {
          node.seek(guildId, Duration.zero);
          break;
        }
      case 'pause':
        {
          node.pause(guildId);
          break;
        }
      case 'resume':
        {
          node.resume(guildId);
          break;
        }
      case 'forward':
        {
          node.skip(guildId);
          break;
        }
      case 'stop':
        {
          node.stop(guildId);

          await event.interaction.message?.delete();
          break;
        }
    }
  }
}
