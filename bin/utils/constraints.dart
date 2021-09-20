import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:nyxx_interactions/interactions.dart';

import 'constants.dart';

Future<bool> checkForOwner(SlashCommandInteractionEvent event) async {
  if (event.interaction.userAuthor?.id.toString() == Tokens.BOT_OWNER) {
    return true;
  }

  return false;
}

Future<bool> checkForMod(SlashCommandInteractionEvent event) async {
  if (await event.interaction.memberAuthor?.effectivePermissions ==
      Permissions.fromInt(PermissionsConstants.manageGuild)) {
    return true;
  }

  return false;
}
