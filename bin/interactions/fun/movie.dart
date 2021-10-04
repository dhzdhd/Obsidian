import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constants.dart';

class FunMovieInteractions {
  final String MOVIE_URL =
      'http://www.omdbapi.com/?apikey=${Tokens.MOVIE_API_KEY}&plot=full';

  FunMovieInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'movie',
      'Get info about a movie.',
      [
        CommandOptionBuilder(
          CommandOptionType.string,
          'title',
          'Name of movie.',
          required: true,
        )
      ],
    )..registerHandler(movieSlashCommand));
  }

  Future<void> movieSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final title = event.getArg('title').value;

    final response = await dio.get(MOVIE_URL, queryParameters: {'t': title});
    final data = response.data;

    final movieEmbed = EmbedBuilder()
      ..title = 'Movie query: **$title**'
      ..description =
          '''
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
      ..thumbnailUrl = data['Poster']
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    await event.respond(MessageBuilder.embed(movieEmbed));
  }
}