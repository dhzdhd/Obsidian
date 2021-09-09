import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../obsidian_dart.dart';

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
            CommandOptionBuilder(
                CommandOptionType.string, 'variable', 'The //FIXME:',
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
    if (expr == '') return '';

    expr = expr.replaceAll('x', '*');

    var eval = 0;
    final p = Parser();
    final cm = ContextModel();

    try {
      final exp = p.parse(expr);
      eval = exp.evaluate(EvaluationType.REAL, cm);
    } on RangeError catch (_) {
      return 'Invalid expression';
    }

    final answer = eval.toString();
    return answer;
  }

  String derive(String variable, String expr) {
    return '';
  }

  Future<void> evalSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final expr = event.getArg('expression').value.toString();

    final result = evaluate(expr);
    await event.respond(MessageBuilder.content(result));
  }

  Future<void> deriveSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
  }
}
