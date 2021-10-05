import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';

class FunMusicInteractions {
  FunMusicInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
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
        )..registerHandler(playMusicSlashCommand)
      ],
    ));
  }

  Future<void> playMusicSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    late VoiceGuildChannel vc;
    var title = event.getArg('title').value.toString();

    var channel = event.interaction.resolved?.channels.first;
    print(channel.toString());

    try {
      var channel = event.interaction.resolved?.channels.first;
      if (channel?.type != ChannelType.voice) {
        throw 'Not a voice channel!';
      }
      vc = channel as VoiceGuildChannel;
    } catch (err) {
      vc = event.interaction.memberAuthor?.voiceState?.channel?.getFromCache()
          as VoiceGuildChannel;
    }

    final node =
        cluster.getOrCreatePlayerNode(event.interaction.guild?.id as Snowflake);
    vc.connect(selfDeafen: true);

    final searchResults = await node.autoSearch(title);

    node
        .play(event.interaction.guild?.id as Snowflake, searchResults.tracks[0])
        .queue();
  }
}
