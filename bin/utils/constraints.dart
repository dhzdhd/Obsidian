import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import 'constants.dart';

Future<bool> checkForOwner(CommandContext context) async {
  if (context.author.id.toString() == Tokens.BOT_OWNER) {
    return true;
  }

  return false;
}

Future<bool> checkForMod(CommandContext context) async {
  if (await context.member?.effectivePermissions ==
      Permissions.fromInt(PermissionsConstants.manageGuild)) {
    return true;
  }

  return false;
}
