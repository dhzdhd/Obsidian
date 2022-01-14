import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constants.dart';
import '../../utils/embed.dart';

class FunMovieInteractions {
  final String movieUrl =
      'http://www.omdbapi.com/?apikey=${Tokens.movieApiKey}&plot=full';

  FunMovieInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'movie',
      'Get info about a movie.',
      [
        CommandOptionBuilder(
          CommandOptionType.string,
          'title',
          'Name of the movie.',
          required: true,
        )
      ],
    )..registerHandler(movieSlashCommand));
  }

  Future<void> movieSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final title = event.getArg('title').value.toString();

    final response = await dio
        .get<String>(movieUrl, queryParameters: <String, String>{'t': title});
    final dynamic data = response.data;

    if (data['Title'] == null) {
      await deleteMessageWithTimer(
        message: await event.sendFollowup(MessageBuilder.embed(errorEmbed(
          'The given movie was not found by the API.\nPlease try again with a different query.',
          event.interaction.userAuthor,
        ))),
      );
      return;
    }

    final movieEmbed = EmbedBuilder()
      ..title = 'Movie query: **$title**'
      ..description = '''
      Title: ${data['Title']}
      Year of release: ${data['Year']}
      Runtime: ${data['Runtime']}
      Genre: ${data['Genre']}
      Director: ${data['Director']}
      Actors: ${data['Actors']}
      Plot: ```${data['Plot']}```
      Language: ${data['Language']}
      Awards: ${data['Awards']}
      IMDB rating: ${data['imdbRating']}
      IMDB votes: ${data['imdbVotes']}
      B/O: ${data['BoxOffice']}
      '''
      ..color = DiscordColor.cyan
      ..timestamp = DateTime.now()
      ..thumbnailUrl = data['Poster'].toString()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    await event.respond(MessageBuilder.embed(movieEmbed));
  }
}
