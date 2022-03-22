import 'package:nyxx_interactions/nyxx_interactions.dart';

import 'constants.dart';

Future<bool> checkForOwner(IInteractionEvent event) async {
  if (event.interaction.userAuthor?.id.toString() == Tokens.botOwner) {
    return true;
  }

  return false;
}

Future<bool> checkForAdmin(IInteractionEvent event) async {
  if ((await event.interaction.memberAuthor?.effectivePermissions)
          ?.administrator ??
      false) {
    return true;
  }

  return false;
}

Future<bool> checkForMod(IInteractionEvent event) async {
  if ((await event.interaction.memberAuthor?.effectivePermissions)
          ?.manageGuild ??
      false) {
    return true;
  }

  return false;
}
