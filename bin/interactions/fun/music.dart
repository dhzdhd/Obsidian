import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:nyxx_lavalink/lavalink.dart';

import '../../obsidian_dart.dart' show cluster, botInteractions, bot;
import '../../utils/constants.dart';
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
            'play',
            'Play some music.',
            options: [
              CommandOptionBuilder(CommandOptionType.string, 'title',
                  'Title of song to be played.',
                  required: true)
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
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'queue',
            'View the current queue.',
          )..registerHandler(queueMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'add',
            'Add a song to the queue.',
            options: [
              CommandOptionBuilder(CommandOptionType.string, 'title',
                  'Title of song to be added to the queue.',
                  required: true)
            ],
          )..registerHandler(addMusicSlashCommand)
        ],
      ))
      ..registerMultiselectHandler('music', musicOptionHandler);
  }

  void initEvents() {
    bot.onVoiceStateUpdate.listen((event) async {
      var buffer = [];

      final botSnowflake = Snowflake(Tokens.BOT_ID);
      final channel =
          await event.state.channel?.getOrDownload() as VoiceGuildChannel;

      final guild = await event.state.guild?.getOrDownload();
      final voiceStates = guild?.voiceStates.asMap.keys.toList();

      if (voiceStates == null) return;
      if (voiceStates.contains(botSnowflake)) {
        buffer.add(botSnowflake);
        voiceStates.remove(botSnowflake);
      } else {
        return;
      }

      print(voiceStates);
    });

    bot.onVoiceServerUpdate.listen((event) async {});
  }

  // ! Add channel input support
  Future<void> playMusicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    late VoiceGuildChannel vc;
    final guildId = event.interaction.guild!.id;
    final title = event.getArg('title').value;

    vc = event.interaction.memberAuthor?.voiceState?.channel?.getFromCache()
        as VoiceGuildChannel;

    final node = cluster.getOrCreatePlayerNode(guildId);
    vc.connect(selfDeafen: true);

    final searchResults = await node.autoSearch(title);
    final track = searchResults.tracks[0];
    final trackInfo = track.info!;

    node.play(guildId, track).queue();

    await event.sendFollowup(
      MessageBuilder.embed(musicEmbed(
        'Play | ${trackInfo.title}',
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
        MultiselectOptionBuilder('Skip', 'skip')
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

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
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

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
    node.resume(event.interaction.guild!.getFromCache()!.id);

    await event.respond(MessageBuilder.embed(
        musicEmbed('Resume', 'Resumed music.', event.interaction.userAuthor)));
  }

  Future<void> pauseMusicSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
    node.pause(event.interaction.guild!.getFromCache()!.id);

    await event.respond(MessageBuilder.embed(
        musicEmbed('Pause', 'Paused music.', event.interaction.userAuthor)));
  }

  Future<void> stopMusicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
    node.stop(event.interaction.guild!.getFromCache()!.id);

    await event.respond(MessageBuilder.embed(musicEmbed(
        'Stop',
        'Stopped music and removed songs from the queue.',
        event.interaction.userAuthor)));
  }

  Future<void> queueMusicSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final guildId = event.interaction.guild!.id;

    final node = cluster.getOrCreatePlayerNode(guildId);
    final player = node.players[Snowflake(guildId)];

    await event.respond(MessageBuilder.embed(musicEmbed(
        'Queue',
        player?.queue.map((e) => e.track.info?.title).join('\n') ??
            'No songs currently in the queue',
        event.interaction.userAuthor)));
  }

  Future<void> addMusicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final title = event.getArg('title').value;
    final guildId = event.interaction.guild!.id;
    final node = cluster.getOrCreatePlayerNode(guildId);
    final player = node.players[Snowflake(guildId)];

    final track = (await node.autoSearch(title)).tracks.first as QueuedTrack;
    player?.queue.add(track);

    await event.respond(MessageBuilder.embed(musicEmbed(
        'Add | ${track.track.info?.title}',
        'Added track to the queue',
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
      case 'skip':
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
