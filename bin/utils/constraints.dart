import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import 'constants.dart';

Future<bool> checkForOwner(SlashCommandInteractionEvent event) async {
  if (event.interaction.userAuthor?.id.toString() == Tokens.BOT_OWNER) {
    return true;
  }

  return false;
}

Future<bool> checkForAdmin(SlashCommandInteractionEvent event) async {
  if ((await event.interaction.memberAuthor?.effectivePermissions)
          ?.administrator ??
      false) {
    return true;
  }

  return false;
}

Future<bool> checkForMod(InteractionEvent event) async {
  if ((await event.interaction.memberAuthor?.effectivePermissions)
          ?.manageGuild ??
      false) {
    return true;
  }

  return false;
}
