import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';

class FunTttInteractions {
  FunTttInteractions() {
    botInteractions.registerSlashCommand(SlashCommandBuilder(
      'Tic Tac Toe',
      'A game of tic tac toe with an opponent.',
      [],
    )..registerHandler(tttSlashCommand));
  }

  Future<void> tttSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
  }
}
