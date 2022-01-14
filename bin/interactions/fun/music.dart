import 'dart:async';
import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';

import '../../obsidian_dart.dart' show cluster, botInteractions, bot;
import '../../utils/constants.dart';
import '../../utils/embed.dart';

class FunMusicInteractions {
  final _random = Random();

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
          )..registerHandler(addMusicSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'shuffle',
            'Shuffle tracks in the current queue.',
          )..registerHandler(shuffleMusicSlashCommand),
        ],
      ))
      ..registerMultiselectHandler('music', musicOptionHandler);
  }

  void initEvents() {
    bot.eventsWs.onVoiceStateUpdate.listen((event) async {
      List<Snowflake> buffer = [];

      final botSnowflake = Snowflake(Tokens.botId);
      // final channel =
      //     await event.state.channel?.getOrDownload() as IVoiceGuildChannel;

      final guild = await event.state.guild?.getOrDownload();
      final voiceStates = guild?.voiceStates.keys.toList();

      if (voiceStates == null) return;
      if (voiceStates.contains(botSnowflake)) {
        buffer.add(botSnowflake);
        voiceStates.remove(botSnowflake);
      } else {
        return;
      }

      print(voiceStates);
    });

    bot.eventsWs.onVoiceServerUpdate.listen((event) async {});
  }

  Future<void> playMusicSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    late final IVoiceGuildChannel vc;
    final guildId = event.interaction.guild!.id;
    final title = event.getArg('title').value.toString();

    // Check if bot is already playing music
    //!
    if (cluster
        .getOrCreatePlayerNode(guildId)
        .createPlayer(guildId)
        .queue
        .isNotEmpty) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Bot is currently occupied in this server!',
          event.interaction.userAuthor)));
      return;
    }

    // Check if user is in a vc
    try {
      vc = event.interaction.memberAuthor?.voiceState?.channel?.getFromCache()
          as IVoiceGuildChannel;
    } catch (err) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'User has not joined a voice channel!\nPlease join a voice channel first.',
          event.interaction.userAuthor)));
      return;
    }

    // Create node and search for song
    final node = cluster.getOrCreatePlayerNode(guildId);
    vc.connect(selfDeafen: true);

    final searchResults = await node.autoSearch(title);
    if (searchResults.tracks.isEmpty) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Song not found! Please try again with a different query.',
          event.interaction.userAuthor)));
    }
    final track = searchResults.tracks[0];
    final trackInfo = track.info!;
    final trackTime =
        '${((trackInfo.length / 1000) / 60).floor()}:${((trackInfo.length / 1000) % 60).round()}';

    node.play(guildId, track).queue();

    await event.sendFollowup(
      MessageBuilder.embed(musicEmbed(
        'Play | ${trackInfo.title}',
        '''
        Artist: ${trackInfo.author}
        Duration: $trackTime minutes
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

  Future<void> skipMusicSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
    node.skip(event.interaction.guild!.getFromCache()!.id);

    await deleteMessageWithTimer(
      message: await event.sendFollowup(MessageBuilder.embed(
          musicEmbed('Skip', 'Skipped music.', event.interaction.userAuthor))),
    );
  }

  Future<void> repeatMusicSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
    final player = node.createPlayer(event.interaction.guild!.id);

    player.queue.add(player.nowPlaying!);

    await deleteMessageWithTimer(
      message: await event.sendFollowup(MessageBuilder.embed(musicEmbed(
          'Resume', 'Resumed music.', event.interaction.userAuthor))),
    );
  }

  Future<void> resumeMusicSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
    node.resume(event.interaction.guild!.getFromCache()!.id);

    await deleteMessageWithTimer(
      message: await event.sendFollowup(MessageBuilder.embed(musicEmbed(
          'Resume', 'Resumed music.', event.interaction.userAuthor))),
    );
  }

  Future<void> pauseMusicSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
    node.pause(event.interaction.guild!.getFromCache()!.id);

    await event.respond(MessageBuilder.embed(
        musicEmbed('Pause', 'Paused music.', event.interaction.userAuthor)));
  }

  Future<void> stopMusicSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final node = cluster.getOrCreatePlayerNode(event.interaction.guild!.id);
    node.stop(event.interaction.guild!.getFromCache()!.id);

    await event.respond(MessageBuilder.embed(musicEmbed(
        'Stop',
        'Stopped music and removed songs from the queue.',
        event.interaction.userAuthor)));
  }

  Future<void> queueMusicSlashCommand(
      ISlashCommandInteractionEvent event) async {
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

  Future<void> addMusicSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final title = event.getArg('title').value.toString();
    final guildId = event.interaction.guild!.id;
    final node = cluster.getOrCreatePlayerNode(guildId);

    final track = (await node.autoSearch(title)).tracks.first;
    node.play(guildId, track).queue();

    await event.respond(MessageBuilder.embed(musicEmbed(
        'Add | ${track.info?.title}',
        'Added track to the queue',
        event.interaction.userAuthor)));
  }

  Future<void> shuffleMusicSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final guildId = event.interaction.guild!.id;
    final node = cluster.getOrCreatePlayerNode(guildId);
    final player = node.players[Snowflake(guildId)];

    if (player?.queue == null || player!.queue.length < 2) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Cannot shuffle the current queue!', event.interaction.userAuthor)));
      return;
    }

    final shuffledQueue = <IQueuedTrack>[];
    for (var _ = 0; _ < player.queue.length; _++) {
      var randomIndex = _random.nextInt(player.queue.length);
      shuffledQueue.add(player.queue[randomIndex]);
      player.queue.removeAt(randomIndex);
    }

    player.queue
      ..clear()
      ..addAll(shuffledQueue);
  }

  Future<void> musicOptionHandler(IMultiselectInteractionEvent event) async {
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
