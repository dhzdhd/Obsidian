import 'dart:isolate';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../obsidian_dart.dart';

class UtilsEvalInteractions {
  UtilsEvalInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'eval',
      'Evaluate dart code.',
      [
        CommandOptionBuilder(
          CommandOptionType.string,
          'code',
          'The code to be evaluated in the form of a function.',
          required: true,
        ),
        CommandOptionBuilder(
          CommandOptionType.string,
          'args',
          'Arguments to the passed function. Pass as comma separated values.',
        )
      ],
    )..registerHandler(evalSlashCommand));
  }

  Future<void> evalSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();

    final function =
        event.getArg('code').value.toString().replaceAll('```', '');
    final functionName = function.split('()')[0].split(' ')[1];
    // ! final args = event.getArg('args').value.split(',') ?? 'bro';
    // print(args);

    final uri = Uri.dataFromString(
      '''
      import 'dart:isolate';
      import 'dart:math';
      import 'dart:cli';
      import 'dart:io' hide exit;

      // For http requests
      import 'package:dio/dio.dart';

      final dio = Dio();

      Future<String> get(String url, {Map<dynamic, dynamic>? params}) async {
        late final response;
        try {
          response = await dio.get(url, queryParameters: params);
        } catch(err) {
          return 'Request failed!';
        }
        return response.data.toString();
      }

      void main(_, SendPort port) {
        port.send($functionName());
      }

      $function
      ''',
      mimeType: 'application/dart',
    );

    final port = ReceivePort();
    final isolate = await Isolate.spawnUri(uri, [], port.sendPort);
    final String response = await port.first;

    port.close();
    isolate.kill();

    var content = function.replaceAll('{', '{\n\t');
    content = content.replaceAll('}', '\n}');
    content = content.replaceAll(';', ';\n\t');

    final evalEmbed = EmbedBuilder()
      ..title = 'Evaluate dart code'
      ..color = DiscordColor.aquamarine
      ..timestamp = DateTime.now()
      ..addField(name: 'Code', content: '```dart\n$content```')
      ..addField(name: 'Output', content: '```dart\n$response```')
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    await event.respond(MessageBuilder.embed(evalEmbed));
  }
}
