import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../obsidian_dart.dart';
import '../../utils/embed.dart';

class UtilsMathInteractions {
  UtilsMathInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'math',
      'Commands related to math.',
      [
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'eval',
          'Evaluate a mathematical expression.',
          options: [
            CommandOptionBuilder(CommandOptionType.string, 'expression',
                'The expression to be evaluated.',
                required: true)
          ],
        )..registerHandler(evalSlashCommand),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'derivative',
          'Find the derivative of a function.',
          options: [
            CommandOptionBuilder(CommandOptionType.string, 'variable',
                'The differentiating variable',
                required: true),
            CommandOptionBuilder(CommandOptionType.string, 'expression',
                'The expression to be evaluated.',
                required: true)
          ],
        )..registerHandler(deriveSlashCommand)
      ],
    ));
  }

  String evaluate(String expr) {
    expr = expr.replaceAll('x', '*');

    late final eval;
    final p = Parser();
    final cm = ContextModel();

    try {
      final exp = p.parse(expr);
      eval = exp.evaluate(EvaluationType.REAL, cm);
    } on RangeError catch (_) {
      return 'Invalid expression';
    } on FormatException catch (_) {
      return 'Invalid expression';
    }

    final result = eval.toString();
    return result;
  }

  String derive(String variable, String expr) {
    final p = Parser();
    final exp = p.parse(expr);

    final result = exp.derive(variable.trim());
    return result.toString();
  }

  String simplify(String expr) {
    final p = Parser();
    final exp = p.parse(expr);

    final result = exp.simplify();
    return result.toString();
  }

  EmbedBuilder createMathEmbed(String title, SlashCommandInteractionEvent event,
      String expr, String result) {
    if (expr == 'Invalid expression') {
      return errorEmbed(
          'Invalid expression entered!', event.interaction.userAuthor);
    }

    return EmbedBuilder()
      ..title = '$title | **$expr**'
      ..description = 'Result: \n$result'
      ..color = DiscordColor.chartreuse
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });
  }

  Future<void> evalSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final expr = event.getArg('expression').value.toString();

    final result = evaluate(expr);

    final embed = createMathEmbed('Evaluate', event, expr, result);
    await event.respond(MessageBuilder.embed(embed));
  }

  Future<void> deriveSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final expr = event.getArg('expression').value.toString();
    final variable = event.getArg('variable').value.toString();

    final result = derive(variable, expr);

    final embed = createMathEmbed('Derive', event, expr, result);
    await event.respond(MessageBuilder.embed(embed));
  }
}
