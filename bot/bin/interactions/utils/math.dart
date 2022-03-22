import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
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
            CommandOptionBuilder(
              CommandOptionType.string,
              'expression',
              'The expression to be evaluated.',
              required: true,
            )
          ],
        )..registerHandler(evalSlashCommand),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'derivative',
          'Find the derivative of a function.',
          options: [
            CommandOptionBuilder(
              CommandOptionType.string,
              'variable',
              'The differentiating variable',
              required: true,
            ),
            CommandOptionBuilder(
              CommandOptionType.string,
              'expression',
              'The expression to be evaluated.',
              required: true,
            )
          ],
        )..registerHandler(deriveSlashCommand)
      ],
    ));
  }

  String evaluate(String expr) {
    expr = expr.replaceAll('x', '*');

    final p = Parser();
    final cm = ContextModel();

    try {
      final exp = p.parse(expr);
      return exp.evaluate(EvaluationType.REAL, cm).toString();
    } catch (_) {
      return 'Invalid expression';
    }
  }

  String derive(String variable, String expr) {
    final p = Parser();

    try {
      final exp = p.parse(simplify(expr));
      final derivative = exp.derive(variable.trim()).toString();
      return simplify(derivative);
    } catch (_) {
      return 'Invalid expression';
    }
  }

  String simplify(String expr) {
    final p = Parser();
    final exp = p.parse(expr);

    return exp.simplify().toString();
  }

  EmbedBuilder createMathEmbed(String title,
      ISlashCommandInteractionEvent event, String expr, String result) {
    if (expr == 'Invalid expression') {
      return errorEmbed(
          'Invalid expression entered!', event.interaction.userAuthor);
    }

    return EmbedBuilder()
      ..title = '$title | **$expr**'
      ..description = result
      ..color = DiscordColor.chartreuse
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });
  }

  Future<void> evalSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final expr = event.getArg('expression').value.toString();

    final result = evaluate(expr);

    final embed = createMathEmbed('Evaluate', event, expr, result);
    await event.respond(MessageBuilder.embed(embed));
  }

  Future<void> deriveSlashCommand(ISlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final expr = event.getArg('expression').value.toString();
    final variable = event.getArg('variable').value.toString();

    if (variable.length != 1) {
      await deleteMessageWithTimer(
        message: await event.sendFollowup(MessageBuilder.embed(errorEmbed(
            'Invalid differentiating variable entered!',
            event.interaction.userAuthor))),
      );
      return;
    }

    final result = derive(variable, expr);

    final embed = createMathEmbed('Derive', event, expr, result);
    await event.respond(MessageBuilder.embed(embed));
  }
}
